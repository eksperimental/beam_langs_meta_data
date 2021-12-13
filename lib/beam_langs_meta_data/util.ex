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
end
