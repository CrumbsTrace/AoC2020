defmodule Day16 do
  @moduledoc """
  Day 16 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day16.p1p2(Day16.parse_input(Helper.get_string_from_file("inputs/Day 16/input.txt")))
      {22057, 1093427331937}
  """
  def p1p2({rules, my_ticket, tickets, names}) do
    p1 = p1(rules, tickets)
    p2 = p2(rules, my_ticket, tickets, names)
    {p1, p2}
  end

  def p1(rules, tickets), do: Enum.map(tickets, fn ticket -> Enum.filter(ticket, fn x -> rules[x] == [] end) |> Enum.sum end) |> Enum.sum()

  def p2(rules, my_ticket, tickets, names) do
    valid_tickets = Enum.filter(tickets, fn ticket -> not Enum.any?(ticket, fn x -> rules[x] == [] end) end)
    valid_tickets
    |> get_all_valid_rules_per_index(rules, names)
    |> determine_rules_per_index()
    |> get_departure_rule_values(my_ticket)
    |> Enum.reduce(fn x, acc -> x * acc end)
  end

  def get_all_valid_rules_per_index(valid_tickets, rules, names) do
    valid_tickets
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn values -> Enum.reduce(values, names, &update_options_for_index(&2, rules[&1])) end)
  end

  def update_options_for_index(options, options_for_value), do: Enum.filter(options, fn name -> name in options_for_value end)

  def get_departure_rule_values(rules, my_ticket) do
    Enum.zip(rules, my_ticket)
    |> Enum.map(fn {name, value} -> if(String.starts_with?(name, "departure"), do: value, else: 1) end)
  end

  @doc """
  Filters the rule options for each index till all indices only have 1 options
  """
  def determine_rules_per_index(options_per_index) do
    if Enum.any?(options_per_index, fn options -> length(options) > 1 end) do
      known_rules = Enum.filter(options_per_index, fn options -> length(options) == 1 end) |> List.flatten()

      options_per_index
      |> Enum.map(&remove_known_rules_from_options(&1, known_rules))
      |> determine_rules_per_index()
    else
      options_per_index |> List.flatten()
    end
  end

  def remove_known_rules_from_options(options, known_rules), do: if(length(options) != 1, do: Enum.filter(options, &not (&1 in known_rules)), else: options)

  def parse_input(input) do
    {rules, remaining_lines, names} = String.split(input, "\n", trim: true) |> parse_rules(Map.new(0..1000 |> Enum.map(fn num -> {num, []} end)), [])
    my_ticket = parse_ticket(hd(remaining_lines))
    tickets = parse_tickets(tl(remaining_lines))
    {rules, my_ticket, tickets, names}
  end

  def parse_tickets([]                     ), do: []
  def parse_tickets([""              |tail]), do: parse_tickets(tail)
  def parse_tickets(["nearby tickets:"|tail]), do: parse_tickets(tail)
  def parse_tickets([head|tail]), do: [parse_ticket(head)|parse_tickets(tail)]

  def parse_ticket(line), do: String.split(line, ",", trim: true) |> Enum.map(&String.to_integer/1)

  def parse_rules(["your ticket:"|tail], map, names), do: {map, tail, names}
  def parse_rules([head|tail], map, names) do
    [name, ranges] = String.split(head, ":", trim: true)
    new_map = ranges |> String.split([" ", "-", "or"], trim: true) |> Enum.map(&String.to_integer/1) |> update_map(name, map)
    parse_rules(tail, new_map, [name|names])
  end

  def update_map([r1_st, r1_end, r2_st, r2_end], name, map) do
    updated_map = r1_st..r1_end |> Enum.reduce(map, fn x, acc -> Map.update!(acc, x, fn list -> [name|list] end) end)
    r2_st..r2_end |> Enum.reduce(updated_map, fn x, acc -> Map.update!(acc, x, fn list -> [name|list] end) end)
  end
end
