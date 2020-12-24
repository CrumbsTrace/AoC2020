defmodule Day23 do
  @moduledoc """
  Day 23 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day23.p1p2(Day23.parse_input("476138259"))
      {"97245386", 156180332979}

  """
  def p1p2(input) do
    p1 = setup_map(input |> Enum.reverse, Map.new(), hd(input)) |> IO.inspect() |> play(hd(input), 0, 100, Enum.max(input))  |> print_map(1, [], 0)

    #p2_map = setup_map(Enum.concat(input, 10..1000000) |> Enum.reverse, Map.new(), hd(input))
    #p2 = p2_map |> play(hd(input), 0, 10000000, 1000000) |> print_p2()
    {p1, 0}
  end

  def play(next_cup_map, _            , max_cycle, max_cycle, _), do: next_cup_map
  def play(next_cup_map, current_value, cycle, max_cycle, max_value) do
    [c1, c2, c3] = get_next_cups(next_cup_map, current_value, 0)

    next_value = next_value(current_value, [current_value, c1, c2, c3], max_value)
    value_after = Map.fetch!(next_cup_map, next_value)

    next_cup_map = next_cup_map |> Map.replace!(current_value, Map.fetch!(next_cup_map, c3)) |> Map.replace!(next_value, c1) |> Map.replace!(c3, value_after)

    play(next_cup_map, Map.fetch!(next_cup_map, current_value), cycle + 1, max_cycle, max_value)
  end

  def next_value(value, next_cups, max_value) when value == 0, do: next_value(max_value, next_cups, max_value)
  def next_value(value, next_cups, max_value), do: if(value in next_cups, do: next_value(value - 1, next_cups, max_value), else: value)

  def get_next_cups(_           , _            , 3), do: []
  def get_next_cups(next_cup_map, current_index, i) do
    next = Map.fetch!(next_cup_map, current_index)
    [next|get_next_cups(next_cup_map, next, i + 1)]
  end

  def parse_input(input), do: input |> split("") |> Enum.map(&String.to_integer/1)

  def split(input, pattern), do: String.split(input, pattern, trim: true)

  def print_p2(map) do
    v1 = Map.get(map, 1)
    v2 = Map.get(map, v1)
    v1 * v2
  end

  def print_map(map, _      , result, count) when map_size(map) == count + 1, do: result |> Enum.reverse |> Enum.join()
  def print_map(map, current, result, count), do: print_map(map, Map.get(map, current), [Map.get(map, current)|result], count + 1)

  def setup_map([]         , map, _       ), do: map
  def setup_map([head|tail], map, previous), do: setup_map(tail, Map.put(map, head, previous), head)

end
