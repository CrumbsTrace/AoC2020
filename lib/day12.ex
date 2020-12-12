defmodule Day12 do
  def euclid({x, y}), do: abs(x) + abs(y)
  @moduledoc """
  Day 12 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day12.p1p2(Day12.parse_input(Helper.get_string_from_file("inputs/Day 12/input.txt")))
      {439, 12385}
  """

  def p1p2(actions) do
    p1 = next_action({{1 , 0}, {0, 0}}, actions, 0) |> euclid()
    p2 = next_action({{10, 1}, {0, 0}}, actions, 1) |> euclid()
    {p1, p2}
  end

  def next_action({_      , ship_pos}, [   ], _ ), do: ship_pos
  def next_action({way_pos, ship_pos}, [h|t], p2), do: do_action(h, way_pos, ship_pos, p2) |> next_action(t, p2)

  def do_action({:N, value}, w_pos     , s_pos     , p2), do: {move(:Y, w_pos,  value, p2), move(:Y, s_pos,  value, (1 - p2))     }
  def do_action({:S, value}, w_pos     , s_pos     , p2), do: {move(:Y, w_pos, -value, p2), move(:Y, s_pos, -value, (1 - p2))     }
  def do_action({:E, value}, w_pos     , s_pos     , p2), do: {move(:X, w_pos,  value, p2), move(:X, s_pos,  value, (1 - p2))     }
  def do_action({:W, value}, w_pos     , s_pos     , p2), do: {move(:X, w_pos, -value, p2), move(:X, s_pos, -value, (1 - p2))     }
  def do_action({:L, value}, w_pos     , s_pos     , _ ), do: {rotate(w_pos, -value)      , s_pos                                 }
  def do_action({:R, value}, w_pos     , s_pos     , _ ), do: {rotate(w_pos,  value)      , s_pos                                 }
  def do_action({:F, value}, {w_x, w_y}, {s_x, s_y}, _ ), do: {{w_x, w_y}                 , {s_x + w_x * value, s_y + w_y * value}}

  def move(:Y, {x, y}, value, p2),  do: {x             , y + value * p2}
  def move(:X, {x, y}, value, p2),  do: {x + value * p2, y             }

  def rotate(w_pos     , degrees) when degrees < 0, do: rotate(w_pos, degrees + 360)
  def rotate({w_x, w_y}, 90 ), do: { w_y, -w_x}
  def rotate({w_x, w_y}, 180), do: {-w_x, -w_y}
  def rotate({w_x, w_y}, 270), do: {-w_y,  w_x}

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn action ->
      action
      |> String.split_at(1)
      |> (fn {instr, value} -> {String.to_existing_atom(instr), String.to_integer(value)} end).()
    end)
  end

end
