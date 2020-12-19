defmodule Day19 do
  @moduledoc """
  Day 19 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day19.p1p2(Day19.parse_input(Helper.get_string_from_file("inputs/Day 19/input.txt")))
      291

      iex> Day19.p1p2(Day19.parse_input(Helper.get_string_from_file("inputs/Day 19/input_p2.txt")))
      409
  """
  def p1p2({rules, messages}), do: Enum.filter(messages, &message_has_valid_branch?(&1, rules)) |> Enum.count()

  def message_has_valid_branch?(msg, rules), do: Enum.member?(indices_at_branch_end(0, msg, rules, 0), tuple_size(msg))

  def indices_at_branch_end(i, msg, _    , _         ) when i >= tuple_size(msg), do: []
  def indices_at_branch_end(i, msg, rules, r_idx), do: rules[r_idx] |> (& if end_of_branch?(&1), do: rule_match(&1, msg, i), else: next_indices(&1, rules, msg, i)).()

  def rule_match(rule, message, index), do: if(first_subrule(rule) == elem(message, index), do: [index + 1], else: [])

  def end_of_branch?(rule), do: rule |> first_subrule() |> is_binary()

  def first_subrule(rule), do: rule |> hd() |> hd()

  def next_indices([]         , _    , _      , _), do: []
  def next_indices([sub_rule|tail], rules, msg, i), do: execute_rule_branch(sub_rule, rules, [i], msg) ++ next_indices(tail, rules, msg, i)

  def execute_rule_branch([]         , _    , idxs, _  ), do: idxs
  def execute_rule_branch([head|tail], rules, idxs, msg), do: execute_rule_branch(tail, rules, execute_rule(idxs, msg, rules, head), msg)

  def execute_rule(indices, message, rules, rule_index), do: Enum.reduce(indices, [], fn x, acc -> indices_at_branch_end(x, message, rules, rule_index) ++ acc end)

  def parse_input(input) do
    all_lines = input |> String.split("\n")
    rules = all_lines |> Enum.reduce_while(%{}, fn line, map -> if line == "", do: {:halt, map}, else: {:cont, parse_rule(line, map)}  end)
    messages = tl(Enum.drop_while(all_lines, & &1 != "")) |> Enum.map(& String.split(&1, "", trim: true) |> List.to_tuple) |> Enum.filter(fn x -> x != {} end)
    {rules, messages}
  end

  def parse_rule(line, map) do
    [index, sub_rules] = String.split(line, ":", trim: true)
    parsed_sub_rules = String.split(sub_rules, "|", trim: true) |> Enum.reduce([], fn sub_rule, acc -> [String.split(sub_rule, " ", trim: true) |> Enum.map(&try_to_int/1)|acc] end)
    Map.put(map, String.to_integer(index), parsed_sub_rules)
  end

  def try_to_int(v) when binary_part(v, 0, 1) != "\"", do: String.to_integer(v)
  def try_to_int(v)                                  , do: String.replace(v, "\"", "")
end
