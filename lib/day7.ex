defmodule Day7 do
  @moduledoc """
  Day 7 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day7.p1p2("inputs/Day 7/input.txt")
      {148, 24867}
  """
  @desired_bag :"shiny gold"
  @containing_bags_regex ~r/\d\s\w*\s\w*\s\w*/
  def p1p2(path) do
    map = path |> get_map()
    p1 = map |> get_bags_with(@desired_bag) |> get_p1_bags(map, []) |> Enum.count()
    p2 = map |> (fn l -> l[@desired_bag] end).() |> get_p2_bag_count(map)
    {p1, p2}
  end

  def get_bags_with(bag_map, name), do: Enum.filter(bag_map, &contains_bag(&1, name)) |> Enum.map(&elem(&1, 0))

  def contains_bag({_, bags}, name), do: Enum.any?(bags , fn {_, bag} -> bag == name end)

  def get_p1_bags([], _, acc), do: acc
  def get_p1_bags([name|tail], bag_map, acc) do
    new_bag = get_p1_bags(tail -- acc, bag_map, [name|acc])
    get_p1_bags(get_bags_with(bag_map, name) -- new_bag, bag_map, new_bag)
  end

  def get_p2_bag_count([], _), do: 0
  def get_p2_bag_count([{count, bag_name}|tail], bag_map) do
    count + get_p2_bag_count(tail, bag_map) + count * get_p2_bag_count(bag_map[bag_name], bag_map)
  end

  def get_bag_name(line) do
    [adj1, adj2 | _] = String.split(line, " ", trim: true)
    String.to_atom(adj1 <> " " <> adj2)
  end

  def get_map(path), do: File.stream!(path) |> Enum.map(fn line -> {get_bag_name(line), get_containing_bags(line)} end)

  def get_containing_bags(line) do
    containing_bags = Regex.scan(@containing_bags_regex, line)

    Enum.map(containing_bags, &hd/1)
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(fn {count, bag} -> {String.to_integer(count), get_bag_name(bag)} end)
  end
end
