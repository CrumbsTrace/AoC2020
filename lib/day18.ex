defmodule Day18 do
  @moduledoc """
  Day 18 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day18.p1p2(Day18.parse_input(Helper.get_string_from_file("inputs/Day 18/input.txt")))
      {510009915468, 321176691637769}
  """
  def p1p2(input) do
    p1 = input |> Enum.map(&evaluate/1) |> Enum.sum()
    p2 = input |> Enum.map(&p2_evaluate/1) |> Enum.sum()
    {p1, p2}
  end

  def p2_evaluate(x) when is_integer(x), do: x
  def p2_evaluate(list), do: addition(list) |> evaluate()

  def addition([])                 , do: []
  def addition([x])                , do: p2_evaluate(x)
  def addition([v1, "+", v2 |tail]), do: p2_evaluate([(p2_evaluate(v1) + p2_evaluate(v2))|tail])
  def addition([v1, "*"     |tail]), do: [p2_evaluate(v1), "*" , p2_evaluate(tail)]

  def evaluate(x)                  when is_integer(x), do: x
  def evaluate([x])                                  , do: evaluate(x)
  def evaluate([v1, "*", v2 |tail])                  , do: evaluate([evaluate(v1) * evaluate(v2)|tail])
  def evaluate([v1, "+", v2 |tail])                  , do: evaluate([evaluate(v1) + evaluate(v2)|tail])

  def group_parentheses([])         , do: []
  def group_parentheses(["("|tail]) , do: get_parentheses_group(tail, []) |> fn {acc, new_tail} -> [acc|group_parentheses(new_tail)] end.()
  def group_parentheses([head|tail]), do: [head|group_parentheses(tail)]

  def get_parentheses_group([")"|tail], acc) , do: {acc |> Enum.reverse(), tail}
  def get_parentheses_group(["("|tail], acc) , do: get_parentheses_group(tail, []) |> fn {inner_acc, new_tail} -> get_parentheses_group(new_tail, [inner_acc|acc]) end.()
  def get_parentheses_group([head|tail], acc), do: get_parentheses_group(tail, [head|acc])

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn line -> Enum.flat_map(line, &String.split(&1, "", trim: true)) end)
    |> Enum.map(fn line -> Enum.map(line, & if(not (&1 in  ["*", "+", "(", ")"]), do: String.to_integer(&1), else: &1)) end)
    |> Enum.map(&group_parentheses/1)
  end

  def pretty_print([])                               , do: ""
  def pretty_print(x) when is_integer(x)             , do: Integer.to_string(x)
  def pretty_print([head|tail]) when is_list(head)   , do: "(" <> pretty_print(head) <> ")" <> pretty_print(tail)
  def pretty_print([head|tail]) when is_integer(head), do: Integer.to_string(head) <> pretty_print(tail)
  def pretty_print([head|tail])                      , do: head <> pretty_print(tail)
end
