defmodule Day3 do
  defguard is_tree(tree_row, x) when elem(tree_row, rem(x, tuple_size(tree_row))) == "#"
  @moduledoc """
  Day 3 of Advent of Code 2020
  """

  @doc """
  ## Examples
      iex> Day3.p1p2(Day3.parse_input(Helper.get_string_from_file("inputs/Day 3/input.txt")))
      {148, 727923200}
  """
  @p1_slopes [{3, 1}]
  @p2_slopes [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
  def p1p2(input) do
    p1 = input |> go_through_slopes(@p1_slopes)
    p2 = input |> go_through_slopes(@p2_slopes)
    {p1, p2}
  end

  def go_through_slopes(_        , []             ),  do: 1
  def go_through_slopes(landscape, [{dx, dy}|tail]),  do: get_tree_count(landscape, dx, dy) * go_through_slopes(landscape, tail)

  def get_tree_count(landscape  ,       dx, dy     ),                       do: get_tree_count(landscape, 0, 0    , dx, dy, 0)
  def get_tree_count([]         , _, _, _ , _ , acc),                       do: acc
  def get_tree_count([_   |tail], x, y, dx, dy, acc) when rem(y, dy) != 0,  do: get_tree_count(tail, x     , y + 1, dx, dy, acc)
  def get_tree_count([head|tail], x, y, dx, dy, acc) when is_tree(head, x), do: get_tree_count(tail, x + dx, y + 1, dx, dy, acc + 1)
  def get_tree_count([_   |tail], x, y, dx, dy, acc),                       do: get_tree_count(tail, x + dx, y + 1, dx, dy, acc)

  def parse_input(input) do
    for line <- String.split(input, "\n", trim: true) do
      line
      |> String.codepoints()
      |> List.to_tuple()
    end
  end

end
