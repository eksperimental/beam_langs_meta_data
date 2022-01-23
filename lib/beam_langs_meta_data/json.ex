defmodule BeamLangsMetaData.Json do
  @moduledoc """
  Provides meta-data for BEAM languages in JSON format.

  So far the only two supported languages are Elixir and Erlang/OTP.

  The data provided by this module in a string of the JSON files.
  For the same data represented in Elixir data stuctures check the `BeamLangsMetaData` module.

  The information in this module is regularly updated, and stored with every new release of this library.
  This library does not download information neither at compile time nor at real time.
  """
  import BeamLangsMetaData.Util

  @external_resource "priv/elixir_releases.json"
  @external_resource "priv/compatibility_elixir_otp.json"
  @external_resource "priv/otp_releases.json"

  @type json() :: String.t()

  @doc ~S"""
  Returns a JSON string containing the Elixir releases data.

  See the documentation for `BeamLangsMetaData.elixir_releases/0` for more information.

  ## Examples

      > BeamLangsMetaData.Json.elixir_releases()
      "[\n  {\n    \"url\": \"https://api.github.com/repos/elixir-lang/" <> ...

  """
  @spec elixir_releases() :: json()
  @elixir_releases priv_dir("elixir_releases.json") |> File.read!()
  def elixir_releases(), do: @elixir_releases

  @doc ~S"""
  Returns a JSON string containing the Erlang/OTP releases.

  See the documentation for `BeamLangsMetaData.otp_releases/0` for more information.

  ## Examples

      > BeamLangsMetaData.Json.otp_releases()
      "[\n  {\n    \"latest\": {\n      \"erlang_download_readme\": " <> ...

  """
  @spec otp_releases() :: json()
  @otp_releases priv_dir("otp_releases.json") |> File.read!()
  def otp_releases(), do: @otp_releases

  @doc ~S"""
  Returns a JSON string containing the compatibilty table between Elixir and Erlang/OTP.

  See the documentation for `BeamLangsMetaData.compatibility/1` for more information.

  ## Examples

      > BeamLangsMetaData.Json.compatibility_elixir_otp()
      "{\n  \"1.0\": [17],\n  \"1.0.5\": [17, 18]," <> ...

  """
  @spec compatibility_elixir_otp :: json()
  @compatibility_elixir_otp priv_dir("compatibility_elixir_otp.json") |> File.read!()
  def compatibility_elixir_otp(), do: @compatibility_elixir_otp
end
