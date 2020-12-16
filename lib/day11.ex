defmodule Day11 do
  defguardp is_too_many(amount, p1) when (p1 and amount > 3) or (not p1 and amount > 4)
  @moduledoc """
  Day 11 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day11.p1p2(Day11.parse_input(Helper.get_string_from_file("inputs/Day 11/input.txt")))
      {2164, 1974}
  """

  def p1p2({w, seats}) do
    p1 = seats |> play_musical_chairs_game_of_life(initialize_adj(seats), w, map_size(seats), true, set_up_dirs(w))
    p2 = seats |> play_musical_chairs_game_of_life(initialize_adj(seats), w, map_size(seats), false, set_up_dirs(w))
    {p1, p2}
  end

  def play_musical_chairs_game_of_life(seats, adj, w, size, p1, dirs) do
    {new_seats, changed} = update_seats(adj, 0, seats, p1, false)
    new_adj = generate_new_adj(new_seats, w, size, p1, dirs, 0)
    if changed, do: play_musical_chairs_game_of_life(new_seats, new_adj, w, size, p1, dirs), else: Enum.count(Map.values(new_seats), & &1)
  end

  def update_seats([         ], _, seats, _    , changed), do: {seats, changed}
  def update_seats([head|tail], i, seats, p1   , changed)  do
    seat = Map.fetch!(seats, i)
    case seat do
      x when (x and is_too_many(head, p1))
        or (not x and head == 0)          -> update_seats(tail, i + 1, Map.update!(seats, i, &not&1), p1, true)
      _                                   -> update_seats(tail, i + 1, seats                        , p1, changed)
    end
  end

  def generate_new_adj(_    , _, size, _ , _   , i) when i >= size, do: []
  def generate_new_adj(seats, w, size, p1, dirs, i),                do: [count_occupied(seats, i, w, size, p1, dirs) | generate_new_adj(seats, w, size, p1, dirs, i + 1)]

  def count_occupied(seats, i, w, size, p1, dirs), do: dirs |> Enum.reduce(0, fn dx, acc -> acc + see_occupied?(seats, i + dx, dx, w, size, p1, dirs) end)

  def see_occupied?(_    , i, dx, w, _   , _, _) when rem(i,      w) == w - 1 and rem(i - dx, w) == 0, do: 0
  def see_occupied?(_    , i, dx, w, _   , _, _) when rem(i - dx, w) == w - 1 and rem(i     , w) == 0, do: 0
  def see_occupied?(_    , i, _ , _, size, _, _) when i < 0 or i >= size,                              do: 0
  def see_occupied?(seats, i, dx, w, size, p1, dirs) do
    case Map.fetch!(seats, i) do
      true -> 1
      false -> 0
      nil -> if(p1, do: 0, else: see_occupied?(seats, i + dx, dx, w, size, p1, dirs))
    end
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)
    {String.length(hd(lines)), Enum.flat_map(lines, fn x -> String.split(x, "", trim: true) end) |> setup_indexed_map()}
  end

  def convert_value("#"), do: true
  def convert_value("L"), do: false
  def convert_value("."), do: nil

  def setup_indexed_map(list), do: list |> Enum.with_index() |> Enum.map(fn {v, i} -> {i, convert_value(v)} end) |> Map.new()

  def initialize_adj(seats), do: Stream.repeatedly(fn -> 0 end) |> Enum.take(map_size(seats))

  def set_up_dirs(w) do
    [-1 -w, -w, -w + 1,
    -1        ,      1,
    -1 + w,  w,  w + 1]
  end
end
