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

  def p1p2(input) do
    p1 = input |> get_tree_count(3, 1)
    p2 = input |> go_through_step_options([{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}])
    {p1, p2}
  end

  def go_through_step_options(_        , [           ]),  do: 1
  def go_through_step_options(landscape, [{h, v}|tail]),  do: get_tree_count(landscape, h, v) * go_through_step_options(landscape, tail)

  def get_tree_count( landscape ,       h, v     ),                       do: get_tree_count(landscape, 0, 0, h, v, 0)
  def get_tree_count([         ], _, _, _, _, acc),                       do: acc
  def get_tree_count([_   |tail], x, y, h, v, acc) when rem(y, v) != 0,   do: get_tree_count(tail, x    , y + 1, h, v, acc)
  def get_tree_count([head|tail], x, y, h, v, acc) when is_tree(head, x), do: get_tree_count(tail, x + h, y + 1, h, v, acc + 1)
  def get_tree_count([_   |tail], x, y, h, v, acc),                       do: get_tree_count(tail, x + h, y + 1, h, v, acc)



  def parse_input(input) do
    for line <- String.split(input, "\n", trim: true) do
      line
      |> String.codepoints()
      |> List.to_tuple()
    end
  end

end
