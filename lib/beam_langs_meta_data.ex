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
          :assets => nonempty_list(elixir_release_data_asset()),
          :assets_url => url(),
          :body => String.t(),
          :created_at => timestamp_string(),
          :draft => boolean(),
          :html_url => url(),
          :id => pos_integer,
          :name => file_name(),
          :node_id => String.t(),
          :prerelease => boolean(),
          :published_at => timestamp_string(),
          :tag_name => git_tag(),
          :tarball_url => url(),
          :target_commitish => git_tag,
          :upload_url => url(),
          :url => url(),
          :zipball_url => url()
        }

  @type elixir_release_data_asset :: %{
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

  @type otp_version :: String.t()

  @typedoc """
  Erlang/OTP release data.
  """
  @type otp_release_data :: %{
          required(:name) => otp_version(),
          required(:readme_url) => url(),
          required(:source_code) => url(),
          required(:tag_name) => git_tag(),
          optional(:doc_html) => url(),
          optional(:doc_man) => url(),
          optional(:published_at) => timestamp_string,
          optional(:release_url) => url(),
          optional(:win32) => url(),
          optional(:win64) => url()
        }

  @doc """
  Returns Elixir releases data.

  The data is a stripped down version of the Elixir releases JSON files from GitHub,
  decoded into a list of maps.

  The source JSON file can be found in <https://api.github.com/repositories/1234714/releases>

  NOTE: The information that gets updated in real time is removed such as number of downloads and reactions.
  Currently `"updated_at"` is also removed, but it will be included when a mechanism to check for
  udpated in any part of the JSON files is implemented. As of now, only the new entries are added to this
  functions, so if there is any correction in a previously entered entry it will not be updated.

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
  @spec elixir_releases() :: nonempty_list(elixir_release_data())
  @elixir_releases priv_dir("elixir_releases.json") |> read_and_decode_json!() |> convert_keys()
  def elixir_releases(), do: @elixir_releases

  @doc """
  Returns Erlang/OTP releases data.

  ## Examples

      > BeamLangsMetaData.otp_releases()
      [
        "24.2": %{
          latest: "24.2",
          releases: [
            "24.2": %{
              doc_html: "https://github.com/erlang/otp/releases/download/OTP-24.2/otp_doc_html_24.2.tar.gz",
              doc_man: "https://github.com/erlang/otp/releases/download/OTP-24.2/otp_doc_man_24.2.tar.gz",
              name: "24.2",
              published_at: "2021-12-15T14:31:36Z",
              readme_url: "https://erlang.org/download/otp_src_24.2.readme",
              release_url: "https://github.com/erlang/otp/releases/tag/OTP-24.2",
              source_code: "https://github.com/erlang/otp/releases/download/OTP-24.2/otp_src_24.2.tar.gz",
              tag_name: "OTP-24.2",
              win32: "https://github.com/erlang/otp/releases/download/OTP-24.2/otp_win32_24.2.exe",
              win64: "https://github.com/erlang/otp/releases/download/OTP-24.2/otp_win64_24.2.exe"
            },
            "24.1.7": %{
              doc_html: "https://" <> ...,
              doc_man: "https://" <> ...,
              name: "24.1.7",
              published_at: "2021-11-22T09:04:55Z",
              readme_url: "https://" <> ...,
              release_url: "https://" <> ...,
              source_code: "https://" <> ...,
              tag_name: "OTP-24.1.7",
              win32: "https://" <> ...,
              win64: "https://" <> ...
            },
            %{...},
            "24.0": %{
              doc_html: "https://" <> ...,
              doc_man: "https://" <> ...,
              name: "24.0",
              ...
            }
          ]
        },
        "23.3": %{
          latest: "23.3.4.10",
          releases: [
            "23.3.4.10": %{
              doc_html: "https://" <> ...,
              ...
            },
          ...],
        },
        ...
      ]

  """
  @spec otp_releases() ::
          nonempty_keyword(
            major_minor_version :: atom(),
            %{
              latest: otp_version(),
              releases: nonempty_keyword(otp_version(), otp_release_data())
            }
          )
  @otp_releases priv_dir("otp_releases.json")
                |> read_and_decode_json!()
                |> convert_keys()
                |> format_otp_releases()
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
