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

  def p2([_              ], seen), do: {1, seen}
  def p2([fst, snd | []  ], seen), do: if(snd - fst == 3,             do: {1, seen}    , else: {0, seen})
  def p2([fst      | tail], seen), do: if(value = Map.get(seen, fst), do: {value, seen}, else: go_through_adapter_options(fst, tail, seen))

  def go_through_adapter_options(fst, tail, seen), do: {0, seen, fst, tail} |> try_next_adapter |> try_next_adapter |> try_next_adapter |> collect_result

  def try_next_adapter({_    , seen, v1, [        ]}),                                 do: {1    , seen, v1, []  }
  def try_next_adapter({count, seen, v1, [v2 |tail]}) when not (v2 - v1 in [1, 2, 3]), do: {count, seen, v1, tail}
  def try_next_adapter({count, seen, v1, [v2 |tail]}),                                 do: p2([v2 | tail], seen) |> process_p2_result(count, v1, tail)

  def process_p2_result({branch_count, new_seen}, count, v1, tail), do: {count + branch_count, new_seen, v1, tail}

  def collect_result({count, seen, v1, _}), do: {count, Map.put(seen, v1, count)}

  def parse_input(input), do: input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1) |> (& [0, Enum.max(&1) + 3 | &1]).() |> Enum.sort()

end
