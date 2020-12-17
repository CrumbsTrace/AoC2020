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
    p1 = map_set |> p1(0, false)
    p2 = map_set |> p1(0, true)
    {p1, p2}
  end

  def p1(map_set, 6, _), do: map_set |> MapSet.to_list() |> Enum.count()
  def p1(map_set, cycle, p2) do
    {min_x, max_x, min_y, max_y, min_z, max_z, min_w, max_w} = Enum.reduce(map_set, {100, 0, 100, 0, 100, 0, 100, 0}, &update_boundaries(&1, &2, p2))

    for x <- min_x..max_x, y <- min_y..max_y, z <- min_z..max_z, w <- min_w..max_w, reduce: %MapSet{} do
      acc -> update_cell_in_map({x, y, z, w}, acc, map_set)
    end
    |> p1(cycle + 1, p2)
  end

  def update_cell_in_map(cell, map_set, old_map_set) do
    if MapSet.member?(old_map_set, cell) do
      if neighbor_count(cell, old_map_set) in 2..3, do: MapSet.put(map_set, cell), else: map_set
    else
      if neighbor_count(cell, old_map_set) == 3   , do: MapSet.put(map_set, cell), else: map_set
    end
  end

  def neighbor_count({c_x, c_y, c_z, c_w}, map_set) do
    for x <- (c_x - 1)..(c_x + 1), y <- (c_y - 1)..(c_y + 1), z <- (c_z - 1)..(c_z + 1), w <- (c_w - 1)..(c_w + 1), reduce: 0 do
      acc -> if MapSet.member?(map_set, {x, y, z, w}) and {x, y, z, w} != {c_x, c_y, c_z, c_w}, do: acc + 1, else: acc
    end
  end
  def update_boundaries({x, y, z, w}, {min_x, max_x, min_y, max_y, min_z, max_z, min_w, max_w}, p2) do
    if p2 do
      {min(x - 1, min_x), max(x + 1, max_x), min(y - 1, min_y), max(y + 1, max_y), min(z - 1, min_z), max(z + 1, max_z), min(w - 1, min_w), max(w + 1, max_w)}
    else
      {min(x - 1, min_x), max(x + 1, max_x), min(y - 1, min_y), max(y + 1, max_y), min(z - 1, min_z), max(z + 1, max_z), 0, 0}
    end
  end


  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.reduce({%MapSet{}, 0}, fn line, {map_set, y} -> {update_map_with_line(line, map_set, 0, y), y + 1} end) |> elem(0)
  end

  def update_map_with_line(""                    , map_set, _, _),                 do: map_set
  def update_map_with_line(<<head, tail::binary>>, map_set, x, y) when head == ?#, do: update_map_with_line(tail, MapSet.put(map_set, {x, y, 0, 0}), x + 1, y)
  def update_map_with_line(<<head, tail::binary>>, map_set, x, y) when head == ?., do: update_map_with_line(tail, map_set                          , x + 1, y)
end
