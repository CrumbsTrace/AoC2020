defmodule Day2 do
  defmodule Password do
    defstruct [:req, :input]
  end

  defmodule Req do
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
    p1 = input |> Enum.count(fn x -> is_regex_match_p1(x) end)
    p2 = input |> Enum.count(fn x -> is_regex_match_p2(x) end)
    {p1, p2}
  end

  def is_regex_match_p1(%Password{req: %Req{lb: lb, ub: ub, rqc: rqc}, input: input}) do
    Regex.match?(~r"^([^#{rqc}]*#{rqc}[^#{rqc}]*){#{lb},#{ub}}$", input)
  end

  def is_regex_match_p2(%Password{req: %Req{lb: lb, ub: ub, rqc: rqc}, input: input}) do
    Regex.match?(~r"^.{#{lb - 1}}#{rqc}", input) != Regex.match?(~r"^.{#{ub - 1}}#{rqc}", input)
  end

  def parse_input(input) do
    for line <- String.split(input, "\n", trim: true) do
      [lb, ub, required_char, password_input] = String.split(line, [" ", "-", ":"], trim: true)
      %Password{req: %Req{lb: String.to_integer(lb), ub: String.to_integer(ub), rqc: required_char}, input: password_input}
    end
  end

end
