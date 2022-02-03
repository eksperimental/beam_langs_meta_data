defmodule BeamLangsMetaDataTest do
  use ExUnit.Case
  doctest BeamLangsMetaData

  setup do
    elixir_releases = BeamLangsMetaData.elixir_releases()
    otp_releases = BeamLangsMetaData.otp_releases()

    {:ok, %{elixir_releases: elixir_releases, otp_releases: otp_releases}}
  end

  describe "elixir_releases/0" do
    test "does not include filtered keys", %{elixir_releases: elixir_releases} do
      assert Keyword.keyword?(elixir_releases) == true

      filtered_keys = [
        :reactions,
        :download_count,
        :updated_at,
        :author,
        :uploader,
        :followers_url
      ]

      for {major_minor, %{latest: latest_otp_version, releases: releases_kw}} <- elixir_releases,
          {version_atom, release_map} <- releases_kw do
        releases_keys = Map.keys(release_map)
        refute filtered_keys in releases_keys

        assert is_atom(major_minor) == true
        assert is_binary(latest_otp_version) == true
        assert is_atom(version_atom) == true
      end
    end

    test "converted values", %{elixir_releases: elixir_releases} do
      required_keys = ~w[
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
      ]a

      required_asset_keys = [
        :browser_download_url,
        :content_type,
        :created_at,
        :id,
        :label,
        :name,
        :node_id,
        :size,
        :state,
        :url
      ]

      for {_major_minor, %{latest: _latest, releases: releases_kw}} <- elixir_releases,
          {_version_atom, release_map} <- releases_kw do
        if id = get_in(release_map, [:id]) do
          assert is_integer(id) == true
        end

        assert get_in(release_map, [:id]) |> is_integer() == true

        assert get_in(release_map, [:assets, Access.all(), :id]) |> Enum.all?(&is_integer/1) ==
                 true

        tag_name = get_in(release_map, [:tag_name])
        name = get_in(release_map, [:name])
        assert is_binary(tag_name) == true
        assert "v" <> name == tag_name

        draft = get_in(release_map, [:draft])
        assert draft in [true, false]

        if Map.has_key?(release_map, :body) do
          for key <- required_keys do
            unless Map.has_key?(release_map, key) do
              flunk("#{key} not found in #{inspect(release_map)}")
            end

            assert get_in(release_map, [:assets, Access.all(), :id]) |> Enum.all?(&is_integer/1) ==
                     true

            tag_name = get_in(release_map, [:tag_name])
            assert is_binary(tag_name) == true
            assert "v" <> _ = tag_name

            draft = get_in(release_map, [:draft])
            assert draft in [true, false]
          end
        else
          for key <- required_keys do
            unless Map.has_key?(release_map, key) do
              flunk("#{key} not found in #{inspect(release_map)}")
            end
          end
        end

        if assets = Map.get(release_map, :assets) do
          assert is_list(assets) == true
          # assert assets != []
          for asset <- assets, key <- required_asset_keys do
            unless Map.has_key?(asset, key) do
              flunk("#{key} not found in #{inspect(asset)}")
            end
          end
        end
      end
    end
  end

  describe "otp_releases/0" do
    test "does not include filtered keys", %{otp_releases: otp_releases} do
      assert Keyword.keyword?(otp_releases) == true

      filtered_keys = [
        :reactions,
        :download_count,
        :updated_at,
        :author,
        :uploader,
        :followers_url
      ]

      for {major, %{latest: latest_otp_version, releases: releases_kw}} <- otp_releases,
          {version_atom, release_map} <- releases_kw do
        releases_keys = Map.keys(release_map)
        refute filtered_keys in releases_keys

        assert is_atom(major) == true
        assert is_binary(latest_otp_version) == true
        assert is_atom(version_atom) == true
      end
    end

    test "converted values", %{otp_releases: otp_releases} do
      required_keys = [:created_at, :name, :tag_name, :tarball_url]

      required_asset_keys = [
        :browser_download_url,
        :content_type,
        :created_at,
        :id,
        :label,
        :name,
        :node_id,
        :size,
        :state,
        :url
      ]

      required_keys_full = ~w[
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
      ]a

      required_download_keys = [
        :doc_html,
        :doc_man,
        :readme,
        :source,
        :win32,
        :win64
      ]

      for {_major_minor, %{latest: _latest, releases: releases_kw}} <- otp_releases,
          {_version_atom, release_map} <- releases_kw do
        if id = get_in(release_map, [:id]) do
          assert is_integer(id) == true
        end

        if Map.has_key?(release_map, :body) do
          for key <- required_keys_full do
            unless Map.has_key?(release_map, key) do
              flunk("#{key} not found in #{inspect(release_map)}")
            end

            assert get_in(release_map, [:assets, Access.all(), :id]) |> Enum.all?(&is_integer/1) ==
                     true

            tag_name = get_in(release_map, [:tag_name])
            assert is_binary(tag_name) == true
            assert "OTP-" <> _ = tag_name

            draft = get_in(release_map, [:draft])
            assert draft in [true, false]

            if Map.has_key?(release_map, :download_urls) do
              download_urls = release_map.download_urls
              assert is_map(download_urls) == true

              for key <- required_download_keys do
                unless Map.has_key?(download_urls, key) do
                  flunk("#{key} not found in #{inspect(release_map)}")
                end

                assert is_binary(download_urls[key]) == true
              end
            end
          end
        else
          for key <- required_keys do
            unless Map.has_key?(release_map, key) do
              flunk("#{key} not found in #{inspect(release_map)}")
            end
          end
        end

        if assets = Map.get(release_map, :assets) do
          assert is_list(assets) == true

          for asset <- assets, key <- required_asset_keys do
            unless Map.has_key?(asset, key) do
              flunk("#{key} not found in #{inspect(asset)}")
            end
          end
        end
      end
    end
  end

  describe "compatibility/1" do
    test "{:elixir, :otp}" do
      compatibility = BeamLangsMetaData.compatibility({:elixir, :otp})

      assert Enum.count(compatibility) >= 19
      assert Map.get(compatibility, "1.0") == [17]
      assert Map.get(compatibility, "1.10.3") == [21, 22, 23]

      for {elixir_version, otp_versions} <- compatibility do
        assert is_binary(elixir_version) == true
        assert is_list(otp_versions) == true
      end
    end

    test "{:otp, :elixir}" do
      compatibility = BeamLangsMetaData.compatibility({:otp, :elixir})

      assert Enum.count(compatibility) >= 8
      assert Map.get(compatibility, 17) == ["1.0", "1.1"]
      assert Map.get(compatibility, 20) == ["1.4.5", "1.5", "1.6", "1.7", "1.8", "1.9"]
      assert Map.get(compatibility, 22) == ["1.10", "1.11", "1.12", "1.13", "1.7", "1.8", "1.9"]

      for {otp_version, elixir_versions} <- compatibility do
        assert is_integer(otp_version) == true
        assert is_list(elixir_versions) == true
      end
    end
  end
end
