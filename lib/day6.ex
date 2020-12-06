defmodule Day6 do
  @moduledoc """
  Day 6 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day6.p1p2(Day6.parse_input(Helper.get_string_from_file("inputs/Day 6/input.txt")))
      {6504, 3351}
  """

  def p1p2(input), do: {p1(input), p2(input)}

  def p2([]         )      , do: 0
  def p2([head|tail])      , do: p2(tail, join_elements(head, [], []))
  def p2([""  |tail], list), do: Enum.count(list) + p2(tail)
  def p2([head|tail], list), do: p2(tail, common_elements(head, list))


  def p1([]         , list), do: Enum.count(list)
  def p1([""  |tail], list), do: Enum.count(list) + p1(tail, [])
  def p1([head|tail], list), do: p1(tail, join_elements(head, list, list))
  def p1([head|tail])      , do: p1(tail, join_elements(head, [], []))


  def common_elements(""         , _              ), do: []
  def common_elements(<<head, tail::binary>>, list)  do
    if Enum.member?(list, head) do
      [head | common_elements(tail, list)]
    else
      common_elements(tail, list)
    end
  end

  def join_elements(""         , _              , acc), do: acc
  def join_elements(<<head, tail::binary>>, [], acc), do: join_elements(tail, [], [head|acc])
  def join_elements(<<head, tail::binary>>, list, acc)  do
    if Enum.member?(list, head) do
      join_elements(tail, list, acc)
    else
      join_elements(tail, list, [head|acc])
    end
  end

  def parse_input(input), do: input |> String.split("\n")
end
