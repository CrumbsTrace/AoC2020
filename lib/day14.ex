defmodule Day14 do
  use Bitwise
  @moduledoc """
  Day 14 of Advent of Code 2020

  1100101
  X110XX0 BITMASK WITH X AS 0

  1110101 OR
  1110110 BITMASK WITH X AS 1

  1110100 AND RESULT



  010100110
  X1110XX10

  011100110
  111101110

  011100110
  """

  @doc ~S"""
  ## Examples
      iex> Day14.p1p2(Day14.parse_input(Helper.get_string_from_file("inputs/Day 14/input.txt")))
      {5055782549997, 4795970362286}
  """

  def p1p2(input) do
    p1 = p1(input, {0, 0}, Map.new())
    p2 = p2(input, {0, 0}, Map.new())
    {p1, p2}
  end

  def p2([]                      , _       , memory_map), do: Map.values(memory_map) |> Enum.sum()
  def p2([["mask", bitmask]|tail], _       , memory_map), do: p2(tail, bitmask, memory_map)
  def p2([[address,  value]|tail], bitmask , memory_map), do: p2(tail, bitmask, p2_update_memory(memory_map, address, bitmask, value))

  def p2_update_memory(memory, address, bitmask, value), do: get_addresses(address, bitmask, 0, 0) |> Enum.reduce(memory, fn addr, acc -> Map.put(acc, addr, value) end)

  def get_addresses([]                       , ""            , acc, _)                  , do: [acc]
  def get_addresses([_    |a_tail], <<b_bit, b_tail::binary>>, acc, i) when b_bit == ?1 , do: get_addresses(a_tail, b_tail, (1     <<< (35 - i)) + acc, i + 1)
  def get_addresses([a_bit|a_tail], <<b_bit, b_tail::binary>>, acc, i) when b_bit == ?0 , do: get_addresses(a_tail, b_tail, (a_bit <<< (35 - i)) + acc, i + 1)
  def get_addresses([_    |a_tail], <<b_bit, b_tail::binary>>, acc, i) when b_bit == ?X , do: get_addresses(a_tail, b_tail, (1     <<< (35 - i)) + acc, i + 1)
                                                                                                ++ get_addresses(a_tail, b_tail, acc, i + 1)

  def p1([]                      , _       , memory_map), do: Map.values(memory_map) |> Enum.sum()
  def p1([["mask", bitmask]|tail], {_ , _ }, memory_map), do: p1(tail, new_bitmaps(bitmask), memory_map)
  def p1([[addr  ,  value]|tail], {b1, b2}, memory_map),  do: p1(tail, {b1, b2}            , Map.put(memory_map, Integer.undigits(addr), (value ||| b1) &&& b2))


  def new_bitmaps(bitmask)                                     , do: new_bitmaps(bitmask, {0, 0}, 0)
  def new_bitmaps(""                 , bitmasks,             _), do: bitmasks
  def new_bitmaps(<<?X,tail::binary>>, {bitmask1, bitmask2}, i), do: new_bitmaps(tail, {bitmask1                   , (1 <<< (35 - i)) + bitmask2}, i + 1)
  def new_bitmaps(<<?1,tail::binary>>, {bitmask1, bitmask2}, i), do: new_bitmaps(tail, {(1 <<< (35 - i)) + bitmask1, (1 <<< (35 - i)) + bitmask2}, i + 1)
  def new_bitmaps(<<?0,tail::binary>>, {bitmask1, bitmask2}, i), do: new_bitmaps(tail, {bitmask1                   , bitmask2}                   , i + 1)

  def parse_input(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn line -> String.split(line, [" = ", "mem[", "]"], trim: true)
                           |> fn [mem, num] -> if(mem != "mask", do: [create_memory_bit_address(mem), String.to_integer(num)], else: [mem, num]) end.() end)
  end

  def create_memory_bit_address(mem) do
    number_in_bits = Integer.digits(String.to_integer(mem), 2)
    (Stream.cycle([0]) |> Enum.take(36 - length(number_in_bits))) ++ number_in_bits
  end
end
