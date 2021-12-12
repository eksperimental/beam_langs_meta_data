ExUnit.start()

defmodule Merge do
  def keys(map) when is_map(map) do
    Enum.reduce(map, [], fn
      {k, v}, acc when is_map(v) -> [k | acc] ++ keys(v)
      {k, _v}, acc -> [k | acc]
    end)
  end
end
