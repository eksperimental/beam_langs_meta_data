defmodule BeamLangsMetaData do
  @moduledoc """
  Provides meta-data for BEAM languages.

  So far the only two supported languages are Elixir and Erlang/OTP.

  The information in this module is regularly updated, and stored with every new release of this library.
  This library does not download information neither at compile time nor at real time.
  """
  import BeamLangsMetaData.Util

  @external_resource "priv/elixir_releases.json"
  @external_resource "priv/compatibility_elixir_otp.json"
  @external_resource "priv/otp_releases.json"

  @typedoc """
  A non-empty keyword list.
  """
  @type nonempty_keyword(key, value) :: nonempty_list({key, value})

  @typedoc """
  A string that represents an Semver version.

  For example: `"1.2.3-rc.4"`.
  """
  @type version_string :: String.t()

  @typedoc """
  A string that represents an Elixir version.

  It does not necessarily need to be a full version, it could be `"MAJOR.MINOR"` or
  `"MAJOR.MINOR.PATCH"`, for example: `"1.2"` or `"1.2.3"`.
  """
  @type elixir_version_key :: String.t()

  @type otp_version :: String.t()

  @typedoc """
  An integer that represents the Erlang/OTP major version.

  For example: `24`.
  """
  @type otp_version_key :: non_neg_integer

  @typedoc """
  A Git tag or a branch name.

  For example: `"v1.13"` or `"OTP-24.0-rc3"`.
  """
  @type git_tag :: String.t()

  @typedoc """
  A pair between two projects, used in `compatibility/1`.

  For example: `{:elixir, :otp}` represents the compatibility between the Elixir and the OTP/Erlang versions.
  """
  @type compatibility_pair :: {:elixir, :otp} | {:otp, :elixir}

  @typedoc """
  A string that represents a URL.

  For example: `"https://elixir-lang.org/"`.
  """
  @type url :: String.t()

  @typedoc """
  A string that represents an iso8601 timestamp.

  For example: `"2021-11-22T09:04:55Z"`.
  """
  @type timestamp_string :: String.t()

  @typedoc """
  A file name

  For example: `"Docs.zip"`.
  """
  @type file_name :: String.t()

  @typedoc """
  Elixir release data.

  This data is extracted from Github JSON release file.
  """
  @type elixir_release_data :: %{
          :assets => nonempty_list(release_data_asset()),
          :assets_url => url(),
          :body => String.t(),
          :created_at => timestamp_string(),
          :draft => boolean(),
          :release_url => url(),
          :id => pos_integer,
          :name => version :: String.t(),
          :node_id => String.t(),
          :prerelease => boolean(),
          :published_at => timestamp_string(),
          :tag_name => git_tag(),
          :tarball_url => url(),
          :target_commitish => git_tag(),
          :upload_url => url(),
          :url => url(),
          :zipball_url => url()
        }

  @type release_data_asset :: %{
          :browser_download_url => url(),
          :content_type => String.t(),
          :created_at => timestamp_string(),
          :id => pos_integer,
          :label => nil | String.t(),
          :name => file_name(),
          :node_id => String.t(),
          :size => non_neg_integer,
          :state => String.t(),
          :url => url()
        }

  @typedoc """
  Erlang/OTP release data.
  """
  @type otp_release_data ::
          %{
            :created_at => timestamp_string(),
            :name => otp_version(),
            :tag_name => git_tag(),
            :tarball_url => url()
          }
          | %{
              :assets => [release_data_asset()],
              :assets_url => url(),
              :body => String.t(),
              :created_at => timestamp_string(),
              :draft => boolean(),
              :id => pos_integer,
              :name => otp_version(),
              :node_id => String.t(),
              :prerelease => boolean(),
              :published_at => timestamp_string(),
              :release_url => url(),
              :tag_name => git_tag(),
              :tarball_url => url(),
              :target_commitish => git_tag(),
              :upload_url => url(),
              :url => url(),
              :zipball_url => url(),
              optional(:download_urls) => %{otp_download_key => url()}
            }

  @type otp_download_key :: :doc_html | :doc_man | :readme | :source | :win32 | :win64

  @doc """
  Returns Elixir releases data.

  The data is a stripped down version of the Elixir releases JSON files from GitHub,
  decoded into a list of maps.

  NOTE: The information that gets updated in real time is removed such as number of downloads and reactions.
  Currently `"updated_at"` is also removed, but it will be included when a mechanism to check for
  udpated in any part of the JSON files is implemented. As of now, only the new entries are added to this
  functions, so if there is any correction in a previously entered entry it will not be updated.

  The sources of this data can be found <https://api.github.com/repositories/1234714/releases?page=1>.

  ## Examples

      > BeamLangsMetaData.elixir_releases()
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
          "release_url" => "https://github.com/elixir-lang/elixir/releases/tag/v1.13.0",
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

  """
  # @spec elixir_releases() :: nonempty_list(elixir_release_data())
  @spec elixir_releases() ::
          nonempty_keyword(
            major_minor_version :: atom(),
            %{
              latest: version_string(),
              releases: nonempty_keyword(elixir_version :: atom(), elixir_release_data())
            }
          )

  @elixir_releases priv_dir("elixir_releases.json")
                   |> read_and_decode_json!()
                   |> format_releases(:elixir)
  def elixir_releases(), do: @elixir_releases

  @doc """
  Returns Erlang/OTP releases data.

  ## Examples

      > BeamLangsMetaData.otp_releases()
      [
        "24.2": %{
          latest: "24.2.1",
          releases: [
            "24.2.1": %{
              assets: [
                %{
                  browser_download_url: "https://github.com/erlang/otp/releases/download/OTP-24.2.1/SHA256.txt",
                  content_type: "text/plain",
                  created_at: "2022-01-25T17:22:17Z",
                  id: 54929204,
                  label: "",
                  name: "SHA256.txt",
                  node_id: "RA_kwDOAAW4j84DRic0",
                  size: 347,
                  state: "uploaded",
                  url: "https://api.github.com/repos/erlang/otp/releases/assets/54929204"
                },
                %{
                  browser_download_url: ...,
                  content_type: ...,
                  created_at: ...,
                  id: ...,
                  label: "",
                  name: ...,
                  node_id: ...,
                  size: ...,
                  state: ...,
                  url: ...
                },
                ...
              ],
              assets_url: "https://api.github.com/repos/erlang/otp/releases/57941240/assets",
              body: "```\nPatch Package:           OTP 24.2.1\nGit Tag:" <>...",
              created_at: "2022-01-22T08:41:48Z",
              draft: false,
              release_url: "https://github.com/erlang/otp/releases/tag/OTP-24.2.1",
              id: 57941240,
              name: "24.2.1",
              node_id: "RE_kwDOAAW4j84DdBz4",
              prerelease: false,
              published_at: "2022-01-25T17:12:12Z",
              tag_name: "OTP-24.2.1",
              tarball_url: "https://api.github.com/repos/erlang/otp/tarball/OTP-24.2.1",
              target_commitish: "master",
              upload_url: "https://uploads.github.com/repos/erlang/otp/releases/57941240/assets{?name,label}",
              url: "https://api.github.com/repos/erlang/otp/releases/57941240",
              zipball_url: "https://api.github.com/repos/erlang/otp/zipball/OTP-24.2.1"
            },
            "24.2": %{
              assets: [
                %{
                  browser_download_url: ...,
                  content_type: ...,
                  created_at: ...,
                  id: ...,
                  label: "",
                  name: ...,
                  node_id: ...,
                  size: ...,
                  state: ...,
                  url: ...,
                },
                ...
              ],
              assets_url: "https://api.github.com/repos/erlang/otp/releases/55351570/assets",
              body: "Erlang/OTP 24.2 is the second maintenance patch release for OTP 24" <> ...,
              created_at: "2021-12-14T18:04:03Z",
              draft: false,
              release_url: "https://github.com/erlang/otp/releases/tag/OTP-24.2",
              id: 55351570,
              name: "24.2",
              node_id: "RE_kwDOAAW4j84DTJkS",
              prerelease: false,
              published_at: "2021-12-15T14:31:36Z",
              tag_name: "OTP-24.2",
              tarball_url: "https://api.github.com/repos/erlang/otp/tarball/OTP-24.2",
              target_commitish: "master",
              upload_url: "https://uploads.github.com/repos/erlang/otp/releases/55351570/assets{?name,label}",
              url: "https://api.github.com/repos/erlang/otp/releases/55351570",
              zipball_url: "https://api.github.com/repos/erlang/otp/zipball/OTP-24.2"
            },
            ...
          ]
        }
      ]

  """
  @spec otp_releases() ::
          nonempty_keyword(
            major_version :: atom(),
            %{
              latest: otp_version(),
              releases: nonempty_keyword(otp_version :: atom(), otp_release_data())
            }
          )
  @otp_releases priv_dir("otp_releases.json")
                |> read_and_decode_json!()
                |> format_releases(:otp)
  def otp_releases(), do: @otp_releases

  @doc """
  Returns a compatibilty table between Elixir and Erlang/OTP, and viceversa.

  The information provided is based on the page
  [Compatibility between Elixir and Erlang/OTP](https://hexdocs.pm/elixir/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp).

  ## Examples

      > BeamLangsMetaData.compatibility({:elixir, :otp})
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

      > BeamLangsMetaData.compatibility({:elixir, :otp})
      %{
        17 => ["1.0", "1.1"],
        18 => ["1.0.5", "1.1", "1.2", "1.3", "1.4", "1.5"],
        19 => ["1.2.6", "1.3", "1.4", "1.5", "1.6", "1.7"],
        20 => ["1.4.5", "1.5", "1.6", "1.7", "1.8", "1.9"],
        21 => ["1.10", "1.11", "1.6", "1.7", "1.8", "1.9"],
        22 => ["1.10", "1.11", "1.12", "1.13", "1.7", "1.8", "1.9"],
        23 => ["1.10.3", "1.11", "1.12", "1.13"],
        24 => ["1.11.4", "1.12", "1.13"]
      }
  """
  @spec compatibility({:elixir, :otp}) :: %{
          elixir_version_key => nonempty_list(otp_version_key)
        }
  @spec compatibility({:otp, :elixir}) :: %{
          otp_version_key => nonempty_list(elixir_version_key)
        }
  @compatibility_elixir_otp priv_dir("compatibility_elixir_otp.json") |> read_and_decode_json!()
  def compatibility({:elixir, :otp}), do: @compatibility_elixir_otp

  @compatibility_otp_elixir compatibility_otp_elixir(@compatibility_elixir_otp)
  def compatibility({:otp, :elixir}), do: @compatibility_otp_elixir
end
