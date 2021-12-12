defmodule ElixirMetaData do
  @moduledoc """
  Provides meta-data for Elixir and Erlang/OTP.

  The information in this module is regularly updated, and stored with every new release of this library.
  This library does not download information neither at compile time nor at real time.
  """
  import ElixirMetaData.Util

  @external_resource "priv/releases.json"
  @external_resource "priv/compatibility.json"

  @typedoc """
  It is a string that represents an Elixir version.

  It does not necessarily need to be a full version, it could be `"MAJOR.MINOR"` or
  `"MAJOR.MINOR.PATCH"`, for example: `"1.2"` or `"1.2.3"`.
  """
  @type elixir_version_key :: String.t()

  @typedoc """
  It is an integer that represents the Erlang/OTP major version.

  For example: `24`.
  """
  @type otp_version_key :: non_neg_integer

  @doc """
  Returns Elixir releases data.

  The data is a stripped down version of the Elixir releases JSON files from GitHub,
  decoded into a list of maps.

  The source JSON file can be found in <https://api.github.com/repositories/1234714/releases>

  NOTE: The information that gets updated in real time is removed such as number of downloads and reactions.
  Currently `"updated_at"` is also removed, but it will be included when a mechanism to check for
  udpated in any part of the JSON files is implemented. As of now, only the new entries are added to this
  functions, so if there is any correction in a previously entender entry it will not be updated.

  ## Examples

      > ElixirMetaData.elixir_releases()
      [
        %{
          "assets" => [
            %{
              "browser_download_url" => "https://github.com/elixir-lang/elixir/releases/download/v1.13.0/Docs.zip",
              "content_type" => "application/zip",
              "created_at" => "2021-12-03T18:25:32Z",
              "id" => 50943932,
              "label" => nil,
              "name" => "Docs.zip",
              "node_id" => "RA_kwDOABLXGs4DCVe8",
              "size" => 2023670,
              "state" => "uploaded",
              "url" => "https://api.github.com/repos/elixir-lang/elixir/releases/assets/50943932"
            },
            %{
              "browser_download_url" => "https://github.com/elixir-lang/elixir/releases/download/v1.13.0/Precompiled.zip",
              "content_type" => "application/zip",
              "created_at" => "2021-12-03T18:25:36Z",
              "download_count" => 958,
              "id" => 50943934,
              "label" => nil,
              "name" => "Precompiled.zip",
              "node_id" => "RA_kwDOABLXGs4DCVe-",
              "size" => 6230020,
              "state" => "uploaded",
              "url" => "https://api.github.com/repos/elixir-lang/elixir/releases/assets/50943934"
            }
          ],
          "assets_url" => "https://api.github.com/repos/elixir-lang/elixir/releases/54599470/assets",
          "body" => "Announcement: " <> ...,
          "created_at" => "2021-12-03T18:03:54Z",
          "draft" => false,
          "html_url" => "https://github.com/elixir-lang/elixir/releases/tag/v1.13.0",
          "id" => 54599470,
          "name" => "",
          "node_id" => "RE_kwDOABLXGs4DQR8u",
          "prerelease" => false,
          "published_at" => "2021-12-03T18:25:51Z",
          "tag_name" => "v1.13.0",
          "tarball_url" => "https://api.github.com/repos/elixir-lang/elixir/tarball/v1.13.0",
          "target_commitish" => "main",
          "upload_url" => "https://uploads.github.com/repos/elixir-lang/elixir/releases/54599470/assets{?name,label}",
          "url" => "https://api.github.com/repos/elixir-lang/elixir/releases/54599470",
          "zipball_url" => "https://api.github.com/repos/elixir-lang/elixir/zipball/v1.13.0"
        },
        %{"assets" => [...], ...},
        %{...},
        ...
      ]

  The sources of this data can be found [here](https://api.github.com/repositories/1234714/releases?page=1).
  """
  @spec elixir_releases() :: nonempty_list(%{String.t() => term})
  @elixir_releases priv_dir("releases.json") |> read_and_decode_json!()
  def elixir_releases(), do: @elixir_releases

  @doc """
  Returns a compatibilty table between Elixir and Erlang/OTP.

  The information provided is based on the page
  [Compatibility between Elixir and Erlang/OTP](https://hexdocs.pm/elixir/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp).

  ## Examples

      > ElixirMetaData.compatibility()
      %{
        "1.0" => [17],
        "1.0.5" => [17, 18],
        "1.1" => [17, 18],
        "1.10" => [21, 22],
        "1.10.3" => [21, 22, 23],
        "1.11" => [21, 22, 23],
        "1.11.4" => [21, 22, 23, 24],
        "1.12" => [22, 23, 24],
        "1.13" => [22, 23, 24],
        ...
      }

  """
  @spec compatibility() :: %{elixir_version_key => nonempty_list(otp_version_key)}
  @compatibility priv_dir("compatibility.json") |> read_and_decode_json!()
  def compatibility(), do: @compatibility
end
