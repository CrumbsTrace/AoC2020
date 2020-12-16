defmodule Day15 do
  @moduledoc """
  Day 15 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day15.p1p2([6,4,12,1,20,0,16])
      {475, 11261}
  """
  def p1p2(input) do
    start_map = start_map(input)
    p1 = play(start_map, 0, length(input) + 1, 2020)
    p2 = play(start_map, 0, length(input) + 1, 30000000)
    {p1, p2}
  end

  def play(_  , prev, max_i, max_i), do: prev
  def play(map, prev, i    , max_i), do: Map.get(map, prev) |> fn value -> play(Map.put(map, prev, i), sub(i, value), i + 1, max_i) end.()

  def sub(v1, v2), do: if(v2 != nil, do: v1 - v2, else: 0)

  def start_map(input), do: input |> Enum.reduce({1, %{}}, fn x, {index, acc} -> {index + 1, Map.put(acc, x, index)} end) |> elem(1)
end
