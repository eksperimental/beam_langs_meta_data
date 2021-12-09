defmodule ElixirMetaData do
  @moduledoc """
  Documentation for `ElixirMetaData`.
  """
  import ElixirMetaData.Util

  @external_resource "priv/releases.json"
  @external_resource "priv/compatibility.json"

  @type elixir_version_key :: String.t()
  @type otp_version_key :: non_neg_integer

  @releases priv_dir("releases.json") |> read_and_decode_json!()

  # source "https://api.github.com/repositories/1234714/releases"
  @spec releases() :: [%{String.t() => term}]
  def releases(), do: @releases

  @compatibility priv_dir("compatibility.json") |> read_and_decode_json!()

  @spec compatibility() :: %{elixir_version_key => nonempty_list(otp_version_key)}
  def compatibility(), do: @compatibility
end
