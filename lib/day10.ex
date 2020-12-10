defmodule Day10 do
  @moduledoc """
  Day 10 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day10.p1p2(Day10.parse_input(Helper.get_string_from_file("inputs/Day 10/input.txt")))
      {1885, 2024782584832}
  """

  def p1p2(input) do
    p1 = p1(input, {0, 0})
    {p2, _} = p2(input, Map.new())
    {p1, p2}
  end

  def p1([_        | [] ], {jolt1, jolt3}),                     do: jolt1 * jolt3
  def p1([fst, snd |tail], {jolt1, jolt3}) when snd - fst == 1, do: p1([snd | tail], {jolt1 + 1, jolt3    })
  def p1([fst, snd |tail], {jolt1, jolt3}) when snd - fst == 3, do: p1([snd | tail], {jolt1    , jolt3 + 1})

  def p2([_                    ], seen), do: {1, seen}
  def p2([fst, snd       | []  ], seen), do: if(snd - fst == 3, do: {1, seen} , else: {0, seen})
  def p2([fst, snd, thrd | tail], seen) do
    case Map.fetch(seen, fst) do
      {:ok, value} -> {value, seen}
      :error       -> {fst, 0, seen, [snd, thrd | tail]} |> check_next_adapter() |> check_next_adapter() |> check_next_adapter() |> collect_result()
    end
  end

  def check_next_adapter({_ , _    , seen, [        ]}),                                 do: {0 , 1    , seen, []  }
  def check_next_adapter({v1, count, seen, [v2 |tail]}) when not (v2 - v1 in [1, 2, 3]), do: {v1, count, seen, tail}
  def check_next_adapter({v1, count, seen, [v2 |tail]}) do
    {new_count, new_seen} = p2([v2|tail], seen)
    {v1, count + new_count, new_seen, tail}
  end

  def collect_result({v1, count, seen, _}), do: {count, Map.put(seen, v1, count)}

  def parse_input(input), do: input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1) |> (& [0, Enum.max(&1) + 3 | &1]).() |> Enum.sort()

end
