defmodule Day25 do
  @moduledoc """
  Day 25 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day25.p1p2(3418282, 8719412)
      9620012

  """
  def p1p2(key1, key2) do
    seven_powers = [1|get_7_powers(1)]
    r1 = find_result_pair(key1, seven_powers, 1, 0)
    encr = do_loop(key2, key2, 1, r1)
    encr
  end

  def do_loop(_, value, max_loop, max_loop), do: value
  def do_loop(key, value, loop, max_loop) do
    do_loop(key, rem(value * key, 20201227), loop + 1, max_loop)
  end
  def find_result_pair(key, seven_powers, current, loop) do
    {acc, loops} = Enum.reduce_while(seven_powers, {current, loop}, fn x, {acc, i} -> if acc * x == key, do: {:halt, {acc * x, i}}, else: if(acc * x > 20201227, do: {:halt, {acc * x, i}}, else: {:cont, {acc, i + 1}}) end)
    if acc == key do
      loops
    else
      find_result_pair(key, seven_powers, rem(acc, 20201227), loops)
    end
  end

  def get_7_powers(previous_value) when previous_value > 8719412, do: []
  def get_7_powers(previous_value) do
    [previous_value * 7|get_7_powers(previous_value * 7)]
  end
end
