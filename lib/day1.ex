defmodule Day1 do
  @moduledoc """
  Day 1 of Advent of Code 2020
  """

  @doc """
  ## Examples
      iex> Day1.p1p2(Helper.get_string_from_file("Day1_input.txt"))
      {440979, 82498112}
  """

  def p1p2(input) do
    value_list = input |> parse_input() |> Enum.sort()
    p1 = value_list |> find_result_pair(2020) |> (fn {v1, v2} -> v1 * v2 end).()
    p2 = value_list |> find_result_trio(2020) |> (fn {v1, v2, v3} -> v1 * v2 * v3 end).()
    {p1, p2}
  end

  def find_result_trio([head | tail], desired_result) do
    case find_result_pair(tail, desired_result - head) do
      nil -> find_result_trio(tail, desired_result)
      {v2, v3} -> {head, v2, v3}
    end
  end

  def find_result_pair([], _), do: nil
  def find_result_pair([head | tail], desired_result) do
    if Enum.member?(tail, desired_result - head), do: {head, desired_result - head}, else: find_result_pair(tail, desired_result)
  end

  def parse_input(input) do
    for value <- String.split(input, "\n", trim: true), do: String.to_integer(value)
  end

end