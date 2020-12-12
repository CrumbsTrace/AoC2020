defmodule Day11 do
  defguardp is_too_many(amount, p1) when (p1 and amount > 3) or (not p1 and amount > 4)
  defmodule Parms do
    defstruct [:w, :size, :p1]
  end
  @moduledoc """
  Day 11 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day11.p1p2(Day11.parse_input(Helper.get_string_from_file("inputs/Day 11/input.txt")))
      {2164, 1974}
  """

  def p1p2({w, seats}) do
    p1 = seats |> play_musical_chairs_game_of_life(initialize_adj(seats), %Parms{w: w, size: map_size(seats), p1: true})
    p2 = seats |> play_musical_chairs_game_of_life(initialize_adj(seats), %Parms{w: w, size: map_size(seats), p1: false})
    {p1, p2}
  end

  def play_musical_chairs_game_of_life(seats, adj, parms) do
    {new_seats, changed} = update_seats(adj, 0, seats, parms, false)
    new_adj = generate_new_adj(new_seats, parms, 0)
    if not changed, do: Enum.count(Map.values(new_seats), & "#" == &1), else: play_musical_chairs_game_of_life(new_seats, new_adj, parms)
  end

  def update_seats([         ], _, seats, _    , changed), do: {seats, changed}
  def update_seats([head|tail], i, seats, parms, changed)  do
    seat = Map.get(seats, i)
    case head do
      c when is_too_many(c, parms.p1) and seat == "#" -> update_seats(tail, i + 1, Map.replace!(seats, i, "L"), parms, true)
      c when c == 0                   and seat == "L" -> update_seats(tail, i + 1, Map.replace!(seats, i, "#"), parms, true)
      _                                               -> update_seats(tail, i + 1, seats, parms, changed)
    end
  end

  def generate_new_adj(_    , parms, i) when i >= parms.size, do: []
  def generate_new_adj(seats, parms, i),                      do: [count_occupied(seats, i, parms) | generate_new_adj(seats, parms, i + 1)]

  def count_occupied(seats, i, p) do
    [-1 - p.w, -p.w, -p.w + 1,
     -1            ,        1,
     -1 + p.w,  p.w,  p.w + 1]
    |> Enum.map(fn dx -> see_occupied?(seats, i + dx, dx, p) end)
    |> Enum.sum()
  end

  def see_occupied?(_    , i, dx, p) when rem(i,      p.w) == p.w - 1 and rem(i - dx, p.w) == 0, do: 0
  def see_occupied?(_    , i, dx, p) when rem(i - dx, p.w) == p.w - 1 and rem(i     , p.w) == 0, do: 0
  def see_occupied?(_    , i, _ , p) when i < 0 or i >= p.size,                              do: 0
  def see_occupied?(seats, i, dx, p) do
    case Map.get(seats, i) do
      "." -> if(p.p1, do: 0, else: see_occupied?(seats, i + dx, dx, p))
      "#" -> 1
      "L" -> 0
    end
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)
    {String.length(hd(lines)), Enum.flat_map(lines, fn x -> String.split(x, "", trim: true) end) |> setup_indexed_map()}
  end

  def setup_indexed_map(list), do: list |> Enum.with_index() |> Enum.map(fn {v, i} -> {i, v} end) |> Map.new()

  def initialize_adj(seats), do: Stream.repeatedly(fn -> 0 end) |> Enum.take(map_size(seats))

  def pretty_print_seats(seats, w), do: seats |> Map.to_list |> Enum.sort_by(fn {i, _} -> i end) |> Enum.map(fn {_, value} -> value end) |> Enum.chunk_every(w) |> IO.inspect()
end
