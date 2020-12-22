defmodule Day22 do
  alias Qex, as: Queue
  @moduledoc """
  Day 22 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day22.p1p2(Day22.parse_input(Helper.get_string_from_file("inputs/Day 22/input.txt")))
      {32448, 32949}

  """
  def p1p2({q1, q2}) do
    p1 = combat(q1, q2) |> elem(0)
    p2 = rec_combat(q1, q2, MapSet.new) |> elem(1) |> calculate_score() |> elem(0)
    {p1, p2}
  end

  def rec_combat(q1, q2, _) when q1 == %Queue{}, do: {false, q2}
  def rec_combat(q1, q2, _) when q2 == %Queue{}, do: {true, q1}
  def rec_combat(q1, q2, configs) do
    if MapSet.member?(configs, {q1, q2}) do
      {true, q1}
    else
      configs = MapSet.put(configs, {q1, q2})

      {q1_pop, q1} = Queue.pop!(q1)
      {q2_pop, q2} = Queue.pop!(q2)

      if Enum.count(q1) >= q1_pop and Enum.count(q2) >= q2_pop do
        sub_q1 = Enum.take(q1, q1_pop) |> Queue.new
        sub_q2 = Enum.take(q2, q2_pop) |> Queue.new
        if p1_always_wins(sub_q1, sub_q2) or rec_combat(sub_q1, sub_q2, MapSet.new) |> elem(0) do
          rec_combat(Queue.push(q1, q1_pop) |> Queue.push(q2_pop), q2, configs)
        else
          rec_combat(q1, Queue.push(q2, q2_pop) |> Queue.push(q1_pop), configs)
        end
      else
        if q1_pop < q2_pop, do: rec_combat(q1, update_queue(q2, q2_pop, q1_pop), configs), else: rec_combat(update_queue(q1, q1_pop, q2_pop), q2, configs)
      end
    end
  end

  def update_queue(queue, v1, v2), do: Queue.push(queue, v1) |> Queue.push(v2)

  def p1_always_wins(q1, q2), do: Enum.max(q1) > Enum.max(q2)

  def calculate_score(queue), do: Enum.reduce(queue, {0, Enum.count(queue)}, fn x, {score, count}  -> {score + x * count, count - 1} end)

  def combat(q1, q2) when q1 == %Queue{}, do: Enum.reduce(q2, {0, Enum.count(q2)}, fn x, {score, count}  -> {score + x * count, count - 1} end)
  def combat(q1, q2) when q2 == %Queue{}, do: Enum.reduce(q1, {0, Enum.count(q1)}, fn x, {score, count}  -> {score + x * count, count - 1} end)
  def combat(q1, q2) do
    {q1_pop, q1} = Queue.pop!(q1)
    {q2_pop, q2} = Queue.pop!(q2)
    if q1_pop < q2_pop, do: combat(q1, Queue.push(q2, q2_pop) |> Queue.push(q1_pop)), else: combat(Queue.push(q1, q1_pop) |> Queue.push(q2_pop), q2)
  end

  def parse_input(input) do
    cards = input |> split("\n") |> tl()
    player1 = cards |> Enum.take_while(& &1 != "Player 2:") |> Enum.map(&String.to_integer/1) |> Queue.new()
    player2 = cards |> Enum.drop_while(& &1 != "Player 2:") |> tl() |> Enum.map(&String.to_integer/1) |> Queue.new()
    {player1, player2}
  end

  def split(input, pattern), do: String.split(input, pattern, trim: true)
end
