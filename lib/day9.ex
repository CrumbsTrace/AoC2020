defmodule Day9 do
  alias Qex, as: Queue
  def push_pop!(sums, value), do: Queue.push(sums, value) |> Queue.pop!() |> elem(1)
  @moduledoc """
  Day 9 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day9.p1p2(Day9.parse_input(Helper.get_string_from_file("inputs/Day 9/input.txt")))
      {27911108, 4023754}
  """

  def p1p2(input) do
    values = input |> List.to_tuple()
    p1 = p1(setup_sums(%Queue{}, values, 0, 1), values, 25)
    p2 = p2(input, p1)
    {p1, p2}
  end

  def p1(sums, values, i), do: if(elem(values, i) in sums, do: p1(update_sums(values, i, sums, 1), values, i + 1), else: elem(values, i))

  def p2([head|tail], p1), do: if(answer = get_min_max(tail, head, p1, head, head), do: answer, else: p2(tail, p1))

  def get_min_max(_          , sum, p1, _  , _  ) when sum > p1,  do: nil
  def get_min_max(_          , sum, p1, min, max) when sum == p1, do: min + max
  def get_min_max([head|tail], sum, p1, min, max),                do: get_min_max(tail, head + sum, p1, min(head, min), max(head, max))

  def update_sums(_    , _, sums, 25    ),  do: sums
  def update_sums(values, i, sums, offset), do: update_sums(values, i, push_pop!(sums, elem(values, i) + elem(values, i - offset)), offset + 1)

  def setup_sums(sums, _     , i, _)      when i > 24,       do: sums
  def setup_sums(sums, values, i, offset) when offset == 25, do: setup_sums(sums, values, i + 1, 1)
  def setup_sums(sums, values, i, offset),                   do: setup_sums(Queue.push(sums, elem(values, i) + elem(values, i + offset)), values, i, offset + 1)

  def parse_input(input), do: input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)

end
