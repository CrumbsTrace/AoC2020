defmodule Day17 do
  @moduledoc """
  Day 17 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day17.p1p2(Day17.parse_input(Helper.get_string_from_file("inputs/Day 17/input.txt")))
      {255, 2340}
  """
  def p1p2(map_set) do
    p1 = map_set |> cycle(0, false)
    p2 = map_set |> cycle(0, true)
    {p1, p2}
  end

  def cycle(map_set, 6, _), do: map_set |> MapSet.size()
  def cycle(map_set, cycle, p2) do
    neighbors = Enum.reduce(map_set, %MapSet{}, &get_neighbors(&1, &2, p2))
    for(cell <- neighbors, valid?(cell, map_set, p2), into: %MapSet{}, do: cell) |> cycle(cycle + 1, p2)
  end

  def valid?(cell, map_set, p2) do
    neighbor_count = neighbor_count(cell, map_set, p2)
    if MapSet.member?(map_set, cell), do: neighbor_count in 2..3, else: neighbor_count == 3
  end

  def neighbor_count(c = {c_x, c_y, c_z, c_w}, map_set, p2) do
    for x <- range(c_x), y <- range(c_y), z <- range(c_z), w <- w_range(c_w, p2), reduce: 0 do
      acc -> if MapSet.member?(map_set, {x, y, z, w}) and {x, y, z, w} != c, do: acc + 1, else: acc
    end
  end

  def get_neighbors({c_x, c_y, c_z, c_w}, map_set, p2), do: for(x <- range(c_x), y <- range(c_y), z <- range(c_z), w <- w_range(c_w, p2), into: map_set, do: {x, y, z, w})

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.reduce({%MapSet{}, 0}, fn line, {map_set, y} -> {update_map(line, map_set, 0, y), y + 1} end) |> elem(0)
  end

  def update_map(""                    , map_set, _, _),                 do: map_set
  def update_map(<<head, tail::binary>>, map_set, x, y) when head == ?#, do: update_map(tail, MapSet.put(map_set, {x, y, 0, 0}), x + 1, y)
  def update_map(<<head, tail::binary>>, map_set, x, y) when head == ?., do: update_map(tail, map_set                          , x + 1, y)

  def range(c), do: (c - 1)..(c + 1)

  def w_range(w, p2), do: if(p2, do: (w - 1)..(w + 1), else: 0..0)
end
