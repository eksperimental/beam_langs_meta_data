defmodule BeamLangsMetaDataTest do
  use ExUnit.Case
  doctest BeamLangsMetaData

  describe "elixir_releases/0" do
    test "does not include filtered keys" do
      elixir_releases = BeamLangsMetaData.elixir_releases()

      filtered_keys = [
        "reactions",
        "download_count",
        "updated_at",
        "author",
        "uploader",
        "followers_url"
      ]

      for release_map <- elixir_releases do
        releases_keys = Merge.keys(release_map)
        assert filtered_keys in releases_keys == false
      end
    end

    test "converted values" do
      elixir_releases = BeamLangsMetaData.elixir_releases()

      for release_map <- elixir_releases do
        assert get_in(release_map, ["id"]) |> is_integer() == true

        assert get_in(release_map, ["assets", Access.all(), "id"]) |> Enum.all?(&is_integer/1) ==
                 true

        tag_name = get_in(release_map, ["tag_name"])
        assert is_binary(tag_name) == true
        assert "v" <> _ = tag_name

        draft = get_in(release_map, ["draft"])
        assert draft in [true, false]
      end
    end
  end

  describe "compatibility/1" do
    test ":elixir_otp" do
      compatibility = BeamLangsMetaData.compatibility(:elixir_otp)

      assert Enum.count(compatibility) >= 19
      assert Map.get(compatibility, "1.0") == [17]
      assert Map.get(compatibility, "1.10.3") == [21, 22, 23]

      for {elixir_version, otp_versions} <- compatibility do
        assert is_binary(elixir_version) == true
        assert is_list(otp_versions) == true
      end
    end
  end
end
