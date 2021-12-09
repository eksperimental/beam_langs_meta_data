defmodule ElixirMetaData do
  @moduledoc """
  Documentation for `ElixirMetaData`.
  """
  import ElixirMetaData.Util

  @type elixir_version_key :: String.t()
  @type otp_version_key :: non_neg_integer

  @releases priv_dir("releases.json") |> read_and_decode_json!()

  @spec releases() :: [%{String.t() => term}]
  @doc url: "https://api.github.com/repositories/1234714/releases"
  def releases(), do: @releases

  @compatibility priv_dir("compatibility.json") |> read_and_decode_json!()

  @spec compatibility() :: %{elixir_version_key => nonempty_list(otp_version_key)}
  def compatibility(), do: @compatibility
end
