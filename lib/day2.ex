defmodule Day2 do
  defmodule Password do
    @moduledoc false
    defstruct [:req, :input]
  end

  defmodule Req do
    @moduledoc false
    defstruct [:lb, :ub, :rqc]
  end
  @moduledoc """
  Day 2 of Advent of Code 2020
  """

  @doc """
  ## Examples
      iex> Day2.p1p2(Day2.parse_input(Helper.get_string_from_file("inputs/Day 2/input.txt")))
      {645,737}
  """

  def p1p2(input) do
    p1 = input |> Enum.count(fn x -> match_p1?(x) end)
    p2 = input |> Enum.count(fn x -> match_p2?(x) end)
    {p1, p2}
  end

  def match_p2?(%Password{req: %Req{lb: lb, ub: ub, rqc: <<rqc>>}, input: input}),                          do: match_p2?(input, rqc, lb, ub, false, 1)
  def match_p2?(<<_::utf8   , tail::binary>> , rqc, lb, ub, found, index) when index != lb and index != ub, do: match_p2?(tail, rqc, lb, ub, found, index + 1)
  def match_p2?(<<head::utf8, tail::binary>> , rqc, lb, ub, _    , index) when index == lb,                 do: match_p2?(tail, rqc, lb, ub, rqc == head, index + 1)
  def match_p2?(<<head::utf8,    _::binary>> , rqc,  _, ub, found, index) when index == ub and found,       do: head != rqc
  def match_p2?(<<head::utf8,    _::binary>> , rqc,  _, ub, found, index) when index == ub and not found,   do: head == rqc

  def match_p1?(%Password{req: %Req{lb: lb, ub: ub, rqc: <<rqc>>}, input: input}),  do: match_p1?(input, rqc, lb, ub, 0)
  def match_p1?(""                          ,  _ , lb , ub,  acc),                  do: acc >= lb and acc <= ub
  def match_p1?(<<head::utf8, tail::binary>>, rqc, lb , ub , acc) when head == rqc, do: match_p1?(tail, rqc, lb, ub, acc + 1)
  def match_p1?(<<head::utf8, tail::binary>>, rqc, lb , ub , acc) when head != rqc, do: match_p1?(tail, rqc, lb, ub, acc    )


  def parse_input(input) do
    for line <- String.split(input, "\n", trim: true) do
      [lb, ub, required_char, password_input] = String.split(line, [" ", "-", ":"], trim: true)
      requirement = %Req{lb: String.to_integer(lb), ub: String.to_integer(ub), rqc: required_char}
      %Password{req: requirement, input: password_input}
    end
  end

end
