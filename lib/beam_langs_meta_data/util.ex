defmodule BeamLangsMetaData.Util do
  @moduledoc false

  def priv_dir(), do: :code.priv_dir(:beam_langs_meta_data)

  def priv_dir(file_path) when is_binary(file_path), do: Path.join(priv_dir(), file_path)

  def read_and_decode_json!(file_path) do
    file_path
    |> File.read!()
    |> Jason.decode!()
  end

  elixir_accepted_keys = ~W(
    assets
    assets_url
    body
    browser_download_url
    content_type
    created_at
    draft
    html_url
    id
    label
    name
    node_id
    prerelease
    published_at
    size
    state
    tag_name
    tarball_url
    target_commitish
    upload_url
    url
    zipball_url
  )

  otp_accepted_keys = ~W(
    erlang_download_readme
    html
    html_url
    latest
    patches
    man
    name
    patch
    published_at
    readme
    release
    src
    tag_name
    win32
    win64
  )

  @accepted_keys elixir_accepted_keys ++ otp_accepted_keys

  def convert_keys(term) when is_map(term),
    do: convert_keys(term, :map)

  def convert_keys(term) when is_list(term),
    do: convert_keys(term, :list)

  def convert_keys(term),
    do: term

  defp convert_keys(term, type) do
    for element <- term, into: into(type) do
      case element do
        {k, v} when k in @accepted_keys ->
          {String.to_atom(k), convert_keys(v)}

        {k, v} ->
          {k, convert_keys(v)}

        _ ->
          convert_keys(element)
      end
    end
  end

  defp into(:map), do: %{}
  defp into(:list), do: []

  def format_otp_releases(list) do
    for entry <- list do
      new_entry = %{
        latest: entry.latest.name,
        releases: format_otp_releases_patches(entry.patches)
      }

      {major_minor(entry.latest.name), new_entry}
    end
  end

  defp major_minor(string) when is_binary(string) do
    String.split(string, ".")
    |> Enum.take(2)
    |> Enum.join(".")
    |> String.to_atom()
  end

  defp nilify(""), do: nil
  defp nilify(term), do: term

  defp format_otp_releases_patches(list) when is_list(list) do
    for entry <- list do
      readme_url =
        cond do
          entry.readme == entry.erlang_download_readme ->
            entry.readme

          readme = nilify(entry.readme) || nilify(entry.erlang_download_readme) ->
            readme

          true ->
            ""
        end

      entry =
        entry
        |> Map.drop([:erlang_download_readme, :readme])
        |> Map.put(:readme_url, readme_url)
        |> map_rename_key(:src, :source_code)
        # |> update_if_exists(:published_at, &to_date_time/1)
        |> otp_releases_rename_keys()

      entry =
        for {k, v} <- entry, into: %{} do
          {k, use_url(v)}
        end

      {String.to_atom(entry.name), entry}
    end
  end

  # defp to_date_time(string) when is_binary(string) do
  #   {:ok, date_time, _offset} = DateTime.from_iso8601(string)
  #   date_time
  # end

  # defp update_if_exists(map, key, fun) when is_map(map) do
  #   case map do
  #     %{^key => value} -> %{map | key => fun.(value)}
  #     %{} -> map
  #   end
  # end

  defp otp_releases_rename_keys(map) when is_map(map) do
    map
    |> map_rename_key(:html, :doc_html)
    |> map_rename_key(:man, :doc_man)
    |> map_rename_key(:html_url, :release_url)
  end

  defp map_rename_key(map, key, new_key)
       when is_map(map) and is_map_key(map, key) and not is_map_key(map, new_key) do
    {value, updated_map} = Map.pop!(map, key)
    Map.put(updated_map, new_key, value)
  end

  defp map_rename_key(map, _key, _new_key) do
    map
  end

  defp use_url(%{id: _id, url: url}), do: url
  defp use_url(term), do: term
end
