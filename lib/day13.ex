defmodule Day13 do
  @moduledoc """
  Day 13 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day13.p1p2(Day13.parse_input(Helper.get_string_from_file("inputs/Day 13/input.txt")))
      {153, 471793476184394}
  """

  def p1p2(input) do
    p1 = input |> p1()
    p2 = input |> p2()
    {p1, p2}
  end

  def p1({timestamp, bus_ids}) do
    bus_ids
    |> Enum.map(fn bus_id -> if bus_id != "x", do: rem(timestamp, bus_id), else: 99999999999 end)
    |> Enum.zip(bus_ids)
    |> Enum.filter(fn {_, x} -> is_number(x) end)
    |> Enum.min_by(fn {remainder, bus_id} -> bus_id - remainder end)
    |> fn {remainder, bus_id} -> (bus_id - remainder) * bus_id end.()
  end

  def p2({_, [hd|tail]}), do: get_p2_answer(hd, hd, tail, 1)

  def get_p2_answer(value, dx, ["x"|tail], i), do: get_p2_answer(value, dx, tail, i + 1)
  def get_p2_answer(value, dx, [bus_id|tail], i) do
    cond do
      invalid?(bus_id, value, i) -> get_p2_answer(value + dx, dx, [bus_id|tail], i)
      tail == []                 -> value
      true                       -> get_p2_answer(value + dx * bus_id, dx * bus_id, tail, i + 1)
    end
  end

  def invalid?(bus_id, value, i), do: rem(value, bus_id) != desired_result((bus_id - i), bus_id)

  def desired_result(value, divisor) when value < 0, do: desired_result(value + divisor, divisor)
  def desired_result(value, _      ), do: value

  def parse_input(input) do
    [timestamp, bus_ids] = input |> String.split("\n", trim: true)
    {String.to_integer(timestamp), String.split(bus_ids, ",", trim: true) |> Enum.map(fn id -> if(id != "x", do: String.to_integer(id), else: id) end)}
  end

end
