defmodule BeamLangsMetaData.Util do
  @moduledoc false

  import BeamLangsMetaData.Helper

  def priv_dir(), do: :code.priv_dir(:beam_langs_meta_data)

  def priv_dir(file_path) when is_binary(file_path), do: Path.join(priv_dir(), file_path)

  def read_and_decode_json!(file_path) do
    file_path
    |> File.read!()
    |> Jason.decode!()
  end

  @accepted_keys ~W(
    assets
    assets_url
    body
    created_at
    draft
    id
    name
    node_id
    prerelease
    published_at
    release_url
    tag_name
    tarball_url
    target_commitish
    upload_url
    url
    zipball_url
  )a

  @assets_accepted_keys ~W(
    browser_download_url
    content_type
    created_at
    id
    label
    name
    node_id
    size
    state
    url
  )a

  def format_releases(list, :otp) do
    list = convert_keys_to_atoms(list)

    for entry <- list do
      latest_name = entry[:latest][:name]

      new_entry = %{
        latest: filter_keys(latest_name, :otp),
        releases: entry[:patches] |> format_release_patches(:otp) |> sort_by_version_key(:desc)
      }

      latest_version = to_version!(latest_name)

      {:"#{latest_version.major}", new_entry}
    end
    |> sort_releases(:desc)
  end

  def format_releases(list, :elixir) do
    list = convert_keys_to_atoms(list)

    grouped =
      Enum.group_by(list, fn x -> major_minor(String.trim_leading(x[:tag_name], "v")) end, fn x ->
        {String.to_atom(String.trim_leading(x[:tag_name], "v")), x}
      end)

    filtered =
      Enum.reject(grouped, fn {k, _v} ->
        Version.match?(to_version!(to_string(k)), "< 1.0.0")
      end)

    for {major_minor, entries} <- filtered do
      latest_name =
        entries
        |> Keyword.keys()
        |> Enum.map(&to_string/1)
        |> Enum.map(&Version.parse!/1)
        |> Enum.max(Version)
        |> to_string()

      entries =
        entries
        |> Enum.map(fn {k, v} -> {:"#{k}", release_rename_keys(v, :elixir)} end)

      new_entry = %{
        latest: latest_name,
        releases: sort_by_version_key(entries, :desc)
      }

      {major_minor, new_entry}
    end
    |> sort_releases(:desc)
  end

  defp sort_releases(releases, order) do
    Enum.sort_by(
      releases,
      fn {k, _v} ->
        k |> to_string() |> to_version!()
      end,
      {order, Version}
    )
  end

  def sort_by_version_key(keyword, order) when is_list(keyword) and order in [:asc, :desc] do
    Enum.sort_by(
      keyword,
      fn
        {version_string, _} when is_binary(version_string) ->
          version_string |> to_version!()

        {version_atom, _} when is_atom(version_atom) ->
          version_atom |> to_string() |> to_version!()
      end,
      {order, Version}
    )
  end

  defp format_release_patches(list, project) when is_list(list) do
    for entry <- list do
      entry = release_rename_keys(entry, project)

      entry =
        for {k, v} <- entry, into: %{} do
          {k, use_url(v)}
        end
        |> filter_keys(:otp)

      {String.to_atom(entry[:name]), entry}
    end
  end

  # returns the MAJOR.MINOR atom version of a version
  defp major_minor(string) when is_binary(string),
    do: string |> String.to_atom() |> major_minor()

  defp major_minor(atom) when is_atom(atom) do
    atom
    |> to_string()
    |> String.split(".")
    |> Enum.take(2)
    |> Enum.join(".")
    |> String.to_atom()
  end

  # defp nilify(""), do: nil
  # defp nilify(term), do: term

  defp release_rename_keys(map, :elixir) when is_map(map) do
    map
    |> map_rename_key(:html_url, :release_url)
  end

  defp release_rename_keys(map, :otp) when is_map(map) do
    map
    # |> map_rename_key(:html, :doc_html)
    # |> map_rename_key(:man, :doc_man)
    |> map_rename_key(:readme, :readme_url)
    |> map_rename_key(:html_url, :release_url)
  end

  defp map_rename_key(map, key, new_key) when is_map(map) do
    if Map.has_key?(map, key) and not Map.has_key?(map, new_key) do
      {value, updated_map} = Map.pop(map, key)
      Map.put(updated_map, new_key, value)
    else
      map
    end
  end

  defp use_url(%{id: _id, url: url}), do: url
  defp use_url(term), do: term

  # Compatiblity
  def compatibility_otp_elixir(elixir_otp_compatibility) do
    for {elixir_version, otp_versions} <- elixir_otp_compatibility,
        otp_version <- otp_versions do
      {otp_version, elixir_version}
    end
    # |> Enum.uniq()
    |> Enum.sort()
    |> Enum.group_by(fn {key, _value} -> key end, fn {_key, value} -> value end)
    |> Enum.map(&filter_elixir_versions/1)
    |> Map.new()
  end

  defp filter_elixir_versions({otp_version, elixir_versions}) do
    new_elixir_versions =
      Enum.reduce(elixir_versions, {[], MapSet.new()}, fn elixir_version, {acc, map_set} ->
        minor_version = minor_version(elixir_version)

        if MapSet.member?(map_set, minor_version) do
          {acc, map_set}
        else
          {[elixir_version | acc], MapSet.put(map_set, minor_version)}
        end
      end)
      |> elem(0)
      |> :lists.reverse()

    {otp_version, new_elixir_versions}
  end

  defp minor_version(elixir_version) when is_binary(elixir_version) do
    elixir_version
    |> String.split(".")
    |> Enum.take(2)
    |> Enum.join(".")
  end

  defp convert_keys_to_atoms(term) when is_list(term) or is_map(term) do
    Enum.reduce(term, into(term), fn
      {k, v}, acc ->
        into(acc, {:"#{k}", convert_keys_to_atoms(v)})

      elem, acc ->
        into(acc, convert_keys_to_atoms(elem))
    end)
  end

  defp convert_keys_to_atoms(term) do
    term
  end

  defp filter_keys(term, accepted_keys_atom) when is_atom(accepted_keys_atom) do
    filter_keys(term, accepted_keys(accepted_keys_atom))
  end

  defp filter_keys(term, accepted_keys_list)
       when (is_map(term) or is_list(term)) and is_list(accepted_keys_list) do
    Enum.reduce(term, into(term), fn
      {k, v}, acc ->
        cond do
          k == :assets ->
            into(acc, {k, filter_keys(v, :assets)})

          k in accepted_keys_list ->
            into(acc, {k, filter_keys(v, accepted_keys_list)})

          true ->
            acc
        end

      elem, acc ->
        into(acc, filter_keys(elem, accepted_keys_list))
    end)
  end

  defp filter_keys(term, accepted_keys_list) when is_list(accepted_keys_list) do
    term
  end

  # defp accepted_keys(:elixir), do: @accepted_keys
  defp accepted_keys(:otp), do: @accepted_keys
  defp accepted_keys(:assets), do: @assets_accepted_keys

  defp into(term) when is_map(term), do: %{}
  defp into(term) when is_list(term), do: []

  defp into(acc, {k, v}) when is_map(acc), do: Map.put(acc, k, v)
  defp into(acc, elem) when is_list(acc), do: [elem | acc]
end
