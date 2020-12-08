defmodule Day8 do
  defmodule Instruction do
    defstruct [:code, :value]
  end
  defguardp cix_is_acc(boot_code, cix) when elem(boot_code, cix).code == :acc
  @moduledoc """
  Day 8 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day8.p1p2(Day8.parse_input("inputs/Day 8/input.txt"))
      {1684, 2188}
  """

  def p1p2(boot_code) do
    {p1, _} = run(boot_code, 0, 0, [], -1, tuple_size(boot_code))
    p2 = get_fixed_boot_code(boot_code, 0, tuple_size(boot_code))
    {p1, p2}
  end

  def get_fixed_boot_code(boot_code, cix, size) when cix_is_acc(boot_code, cix), do: get_fixed_boot_code(boot_code, cix + 1, size)
  def get_fixed_boot_code(boot_code, cix, size),                                 do: run(boot_code, 0, 0, [], cix, size) |> validate(boot_code, cix, size)

  def run(_        , acc, pointer, _, _, size) when pointer >= size, do: {acc, pointer - 1}
  def run(boot_code, acc, pointer, seen, cix, size) do
    instr = elem(boot_code, pointer)
    code = fix_code_if_necessary(instr.code, pointer, cix)
    case code do
      :nop -> run_check(boot_code, acc,               pointer + 1,           [pointer | seen], cix, size)
      :acc -> run_check(boot_code, acc + instr.value, pointer + 1,           [pointer | seen], cix, size)
      :jmp -> run_check(boot_code, acc,               pointer + instr.value, [pointer | seen], cix, size)
    end
  end

  def run_check(boot_code, acc, pointer, seen, cix, size), do: if(loop?(seen, pointer), do: {acc, pointer - 1}, else: run(boot_code, acc, pointer, seen, cix, size))

  def loop?(seen, pointer), do: Enum.member?(seen, pointer)

  def validate({acc, p}, _, _, size) when p == size - 1, do: acc
  def validate(_ ,     boot_code, i, size),              do: get_fixed_boot_code(boot_code, i + 1, size)

  def fix_code_if_necessary(:jmp, pix, cix) when pix == cix, do: :nop
  def fix_code_if_necessary(:nop, pix, cix) when pix == cix, do: :jmp
  def fix_code_if_necessary(code, _  , _),                   do: code

  def parse_input(file), do: File.stream!(file) |> Enum.map(fn x -> String.split(x, [" ", "\n"]) |> initialize_instruction end) |> List.to_tuple()

  def initialize_instruction([instruction, value | _]), do: %Instruction{code: String.to_existing_atom(instruction), value: String.to_integer(value)}

end
