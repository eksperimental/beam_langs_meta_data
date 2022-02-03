defmodule BeamLangsMetaData.Helper do
  @moduledoc """
  Helper functions
  """

  @doc """
  Converts a fully or non-fully qualified string or an integer to a version struct.
  """
  @spec to_version!(String.t() | non_neg_integer() | Version.t()) :: Version.t()
  def to_version!(version) when is_integer(version) do
    Version.parse!("#{version}.0.0")
  end

  def to_version!(version) when is_binary(version) do
    case Version.parse(version) do
      {:ok, version_struct} ->
        version_struct

      :error ->
        parse_version!(version)
    end
  end

  def to_version!(%Version{} = version) do
    version
  end

  defp parse_version!(string) do
    {major_minor_patch, pre_build} =
      case String.split(string, "-", parts: 2) do
        [major_minor_patch] ->
          {major_minor_patch, ""}

        [major_minor_patch, pre_build] ->
          {major_minor_patch, pre_build}
      end

    version =
      case String.split(major_minor_patch, ".", parts: 4) do
        [major] ->
          major <> ".0.0" <> prefix_pre_build(pre_build)

        [major, minor] ->
          major <> "." <> minor <> ".0" <> prefix_pre_build(pre_build)

        [major, minor, patch] ->
          major <> "." <> minor <> "." <> patch <> prefix_pre_build(pre_build)

        [major, minor, patch, extra] ->
          major <>
            "." <> minor <> "." <> patch <> prefix_pre_build(extra) <> prefix_pre_build(pre_build)
      end

    Version.parse!(version)
  end

  defp prefix_pre_build(""), do: ""
  defp prefix_pre_build(string), do: "-" <> string
end
