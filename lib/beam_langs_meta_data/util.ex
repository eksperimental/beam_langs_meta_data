defmodule BeamLangsMetaData.Util do
  @moduledoc false

  import BeamLangsMetaData.Helper, only: [to_version!: 1]

  @otp_version_requirement ">= 17.0.0"

  def priv_dir(), do: :code.priv_dir(:beam_langs_meta_data)

  def priv_dir(file_path) when is_binary(file_path), do: Path.join(priv_dir(), file_path)

  def read_and_decode_json!(file_path) do
    file_path
    |> File.read!()
    |> Jason.decode!()
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

  defp into(term) when is_map(term), do: %{}
  defp into(term) when is_list(term), do: []

  defp into(acc, {k, v}) when is_map(acc), do: Map.put(acc, k, v)
  defp into(acc, elem) when is_list(acc), do: [elem | acc]

  # find the latest version of a list of relesases
  defp get_latest_version(entries) do
    entries
    |> Keyword.keys()
    |> Enum.map(&to_string/1)
    |> Enum.map(&Version.parse!/1)
    |> Enum.max(Version)
    |> to_string()
  end

  defp put_if_not_nil(map, _key, nil),
    do: map

  defp put_if_not_nil(map, key, value),
    do: Map.put(map, key, value)

  defp build_assets(assets) do
    for json_asset <- assets do
      %{
        content_type: json_asset.content_type,
        created_at: json_asset.created_at,
        download_url: json_asset.browser_download_url,
        id: json_asset.id,
        label: json_asset[:label],
        name: json_asset.name,
        node_id: json_asset.node_id,
        size: json_asset.size,
        state: json_asset.state,
        url: json_asset.url
      }
      |> put_if_not_nil(:updated_at, json_asset[:updated_at])
      |> put_if_not_nil(:uploader, json_asset[:uploader])
    end
  end

  def build_releases(list, :elixir) do
    list = convert_keys_to_atoms(list)

    grouped =
      Enum.group_by(list, fn x -> major_minor(String.trim_leading(x[:tag_name], "v")) end, fn x ->
        {String.to_atom(String.trim_leading(x[:tag_name], "v")), x}
      end)

    pre_filtered =
      Enum.reject(grouped, fn {k, _v} ->
        Version.match?(to_version!(to_string(k)), "< 1.0.0")
      end)

    for {major_minor, entries} <- pre_filtered do
      latest_name = get_latest_version(entries)

      entries =
        entries
        |> Enum.map(fn {version, json_entry} ->
          assets = build_assets(json_entry.assets)

          entry = %{
            assets: assets,
            assets_url: json_entry.url,
            author: json_entry.author,
            body: json_entry.body,
            created_at: json_entry.created_at,
            draft: json_entry.draft,
            release_url: json_entry.html_url,
            id: json_entry.id,
            name: String.trim_leading(json_entry.tag_name, "v"),
            node_id: json_entry.node_id,
            prerelease: json_entry.prerelease,
            published_at: json_entry.published_at,
            tag_name: json_entry.tag_name,
            tarball_url: json_entry.tarball_url,
            target_commitish: json_entry.target_commitish,
            upload_url: json_entry.upload_url,
            url: json_entry.url,
            zipball_url: json_entry.zipball_url
          }

          {:"#{version}", entry}
        end)

      new_entry = %{
        latest: latest_name,
        releases: entries |> sort_by_version_key(:desc)
      }

      {major_minor, new_entry}
    end
    |> sort_releases(:desc)
  end

  def build_releases(list, :otp) do
    list = convert_keys_to_atoms(list)

    pre_filtered =
      Enum.filter(list, fn %{release: major_string} ->
        version = to_version!(major_string)
        Version.match?(version, @otp_version_requirement)
      end)

    for %{release: major_string, patches: entries, latest: _latest} <- pre_filtered do
      entries =
        entries
        |> Enum.map(fn %{name: name} = json_entry ->
          entry =
            if json_entry[:body] do
              assets = build_assets(json_entry.assets)

              %{
                assets: assets,
                assets_url: json_entry.url,
                body: json_entry.body,
                created_at: json_entry.created_at,
                draft: json_entry.draft,
                release_url: json_entry.html_url,
                id: json_entry.id,
                name: name,
                node_id: json_entry.node_id,
                prerelease: json_entry.prerelease,
                published_at: json_entry.published_at,
                tag_name: json_entry.tag_name,
                tarball_url: json_entry.tarball_url,
                target_commitish: json_entry.target_commitish,
                upload_url: json_entry.upload_url,
                url: json_entry.url,
                zipball_url: json_entry.zipball_url
              }
            else
              %{
                created_at: json_entry.created_at,
                name: name,
                tag_name: json_entry.tag_name,
                tarball_url: json_entry.tarball_url
              }
            end

          {:"#{name}", entry}
        end)
        |> sort_by_version_key(:desc)

      new_entry = %{
        latest: entries |> List.first() |> elem(0) |> to_string(),
        releases: entries
      }

      {:"#{major_string}", new_entry}
    end
    |> sort_releases(:desc)
  end
end
