defmodule Day1 do
  @moduledoc """
  Day 1 of Advent of Code 2020
  """

  @doc """
  ## Examples
      iex> Day1.p1p2(Day1.parse_input(Helper.get_string_from_file("inputs/Day 1/My_Input.txt")))
      {440979, 82498112}
  """

  @spec p1p2(binary) :: {number, number}
  def p1p2(input) do
    value_list = Enum.sort(input)
    p1 = value_list |> find_result_pair(2020) |> (fn {v1, v2} -> v1 * v2 end).()
    p2 = value_list |> find_result_trio(2020) |> (fn {v1, v2, v3} -> v1 * v2 * v3 end).()
    {p1, p2}
  end

  @spec find_result_trio([...], number) :: {number, number, number}
  def find_result_trio([head | tail], desired_result) do
    case find_result_pair(tail, desired_result - head) do
      nil -> find_result_trio(tail, desired_result)
      {v2, v3} -> {head, v2, v3}
    end
  end

  @spec find_result_pair(list, number) :: nil | {number, number}
  def find_result_pair([],                         _),                             do: nil
  def find_result_pair([head | _   ], desired_result) when head >= desired_result, do: nil
  def find_result_pair([head | tail], desired_result) when head < desired_result do
    if sorted_member?(tail, desired_result - head) do
      {head, desired_result - head}
    else
      find_result_pair(tail, desired_result)
    end
  end

  @spec sorted_member?(list, number) :: boolean
  def sorted_member?([], _), do: false
  def sorted_member?([head|_], element) when head > element, do: false
  def sorted_member?([head|_], element) when head == element, do: true
  def sorted_member?([head|tail], element) when head < element, do: sorted_member?(tail, element)

  @spec parse_input(binary) :: [number]
  def parse_input(input) do
    for value <- String.split(input, "\n", trim: true), do: String.to_integer(value)
  end

  @spec e(any) :: {number, number}
  @doc "The short solution"
  def e(l) do
    [x|_] = for i <- l, j <- l, i + j == 2020, do: i * j
    [y|_] = for i <- l, j <- l, k <- l, i + j + k == 2020, do: i * j * k
    {x, y}
  end

  def do_thing(parameter_value) when parameter_value > 0 do
    #Do Things
  end

  def do_thing(parameter_value) when parameter_value <= 0 do
    #Do Something Else
  end

end
