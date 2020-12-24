defmodule Day24 do
  @moduledoc """
  Day 24 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day24.p1p2(Day24.parse_input(Helper.get_string_from_file("inputs/Day 24/input.txt")))
      {277, 3531}

  """
  def p1p2(input) do
    black_tiles = determine_black_tiles(input)
    p1 = black_tiles |> MapSet.size()
    p2 = black_tiles |> p2(0, 100)
    {p1 , p2}
  end

  def p2(black_tiles, max_cycle, max_cycle), do: black_tiles |> MapSet.size()
  def p2(black_tiles, cycle, max_cycle) do
    neighbors = Enum.reduce(black_tiles, [], fn x, acc -> Enum.reduce(get_neighbors(x), acc, & [&1|&2]) end) |> MapSet.new()
    Enum.filter(neighbors, &black?(&1, black_tiles)) |> MapSet.new() |> p2(cycle + 1, max_cycle)
  end

  def black?(tile, black_tiles) do
    black_tile_neighbor_count = Enum.count(get_neighbors(tile), & MapSet.member?(black_tiles, &1))
    if MapSet.member?(black_tiles, tile), do: black_tile_neighbor_count > 0 and black_tile_neighbor_count <= 2, else: black_tile_neighbor_count == 2
  end

  def determine_black_tiles(input) do
    input
    |> Enum.map(&navigate(&1, 0, 0, 0))
    |> Enum.frequencies()
    |> Enum.filter(fn {_, frequency} -> rem(frequency, 2) == 1 end)
    |> Enum.map(&elem(&1, 0))
    |> MapSet.new()
  end

  def get_neighbors({0, r, c}), do: [{0, r, c + 1}, {0, r, c - 1}, {1, r, c}, {1, r, c - 1}, {1, r - 1, c}, {1, r - 1, c - 1}]
  def get_neighbors({1, r, c}), do: [{1, r, c + 1}, {1, r, c - 1}, {0, r, c}, {0, r, c + 1}, {0, r + 1, c}, {0, r + 1, c + 1}]

  def navigate(""    , a, r, c), do: {a, r, c}
  def navigate(<<"se", tail::binary>>, a, r, c), do: if(a == 1, do: navigate(tail, 0, r + 1, c + 1), else: navigate(tail, 1, r    , c    ))
  def navigate(<<"sw", tail::binary>>, a, r, c), do: if(a == 1, do: navigate(tail, 0, r + 1, c    ), else: navigate(tail, 1, r    , c - 1))
  def navigate(<<"ne", tail::binary>>, a, r, c), do: if(a == 1, do: navigate(tail, 0, r    , c + 1), else: navigate(tail, 1, r - 1, c    ))
  def navigate(<<"nw", tail::binary>>, a, r, c), do: if(a == 1, do: navigate(tail, 0, r    , c    ), else: navigate(tail, 1, r - 1, c - 1))
  def navigate(<<"e", tail::binary>>, a, r, c),  do: navigate(tail, a, r, c + 1)
  def navigate(<<"w", tail::binary>>, a, r, c),  do: navigate(tail, a, r, c - 1)

  def parse_input(input), do: input |> split("\n")

  def split(input, pattern), do: String.split(input, pattern, trim: true)

end
