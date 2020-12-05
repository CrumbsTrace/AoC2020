defmodule Day5 do
  use Bitwise
  @moduledoc """
  Day 5 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day5.p1p2(String.split(Helper.get_string_from_file("inputs/Day 5/input.txt"), "\n", trim: true))
      {989, 548}
  """

  def p1p2(input) do
    seat_ids = input |> get_seat_ids() |> Enum.sort() |> Enum.reverse()
    p1 = hd(seat_ids)
    p2 = find_seat(seat_ids)
    {p1, p2}
  end

  def find_seat([fst, snd, _    | _   ]) when fst == snd + 2,  do: snd + 1
  def find_seat([_  , snd, thrd | tail])                    ,  do: find_seat([snd, thrd | tail])

  def get_seat_ids(input), do: Enum.map(input, &get_seat_id(&1))

  def get_seat_id(<<c1, c2, c3, c4, c5, c6, c7, c8, c9, c10>>) do
    (tb(c1) <<< 9) + (tb(c2) <<< 8) + (tb(c3) <<< 7) + (tb(c4) <<< 6) + (tb(c5) <<< 5) + (tb(c6) <<< 4) + (tb(c7) <<< 3) + (tb(c8) <<< 2) + (tb(c9) <<< 1) + tb(c10)
  end

  def tb(instruction), do: if(instruction == ?B or instruction == ?R, do: 1, else: 0)

end
