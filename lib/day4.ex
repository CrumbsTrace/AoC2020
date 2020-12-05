defmodule Day4 do
  defmodule Passport do
    @moduledoc false
    defstruct [:iyr, :ecl, :hgt, :pid, :byr, :hcl, :eyr, :cid]
  end

  defguardp is_inches(input) when binary_part(input, byte_size(input), -2) == "in"
  defguardp is_cm(input) when binary_part(input, byte_size(input), -2) == "cm"
  defguardp is_hex(c) when c >= ?0 and c <= ?9 or c >= ?a and c <= ?f
  defguardp is_digit(c) when c >= ?0 and c <= ?9
  @moduledoc """
  Day 4 of Advent of Code 2020
  """

  @doc """
  ## Examples
      iex> Day4.p1p2(Day4.parse_input(Helper.get_string_from_file("inputs/Day 4/input.txt")))
      {254, 184}
  """

  def p1p2(input) do
    p1 = valid_passport_count(input, false)
    p2 = valid_passport_count(input, true)
    {p1, p2}
  end

  def valid_passport_count([], _                    ), do: 0
  def valid_passport_count([passport|tail], validate), do: valid_passport(passport, validate) + valid_passport_count(tail, validate)

  def convert_to_cm(input) when is_inches(input), do: round(height_as_value(input) * 2.54)
  def convert_to_cm(input) when is_cm(input)    , do: height_as_value(input)
  def convert_to_cm(_    )                      , do: 0

  def height_as_value(height_string), do: String.to_integer(binary_part(height_string, 0, byte_size(height_string) - 2))

  def valid_passport(%Passport{iyr: iyr, byr: byr, eyr: eyr, hgt: hgt, pid: pid, ecl: ecl, hcl: hcl}, validate) do
    result =
        valid_fld?("iyr", iyr, validate)
    and valid_fld?("byr", byr, validate)
    and valid_fld?("eyr", eyr, validate)
    and valid_fld?("hgt", hgt, validate)
    and valid_fld?("pid", pid, validate)
    and valid_fld?("ecl", ecl, validate)
    and valid_fld?("hcl", hcl, validate)
    if result, do: 1, else: 0
  end

  def valid_fld?("cid", _    , _    ), do: true
  def valid_fld?(_    , nil  , _    ), do: false
  def valid_fld?("iyr", value, true ), do: value in 2010..2020
  def valid_fld?("byr", value, true ), do: value in 1920..2002
  def valid_fld?("eyr", value, true ), do: value in 2020..2030
  def valid_fld?("hgt", value, true ), do: value in 150..193
  def valid_fld?("pid", value, true ), do: pid?(value)
  def valid_fld?("ecl", value, true ), do: value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  def valid_fld?("hcl", value, true ), do: hair_color?(value)
  def valid_fld?(_    , value, false), do: value != nil

  def convert_to_passports([head|[]  ], passport), do: [check_fields(head, passport)]
  def convert_to_passports([""  |tail], passport), do: [passport|convert_to_passports(tail, %Passport{})]
  def convert_to_passports([head|tail], passport), do: convert_to_passports(tail, check_fields(head, passport))

  def check_fields(fields, passport) when is_binary(fields), do: check_fields(String.split(fields, [" ", ":"], trim: true), passport)
  def check_fields([]                  , passport)         , do: passport
  def check_fields([field, value| tail], passport) do
    case field do
      "iyr" -> check_fields(tail, %Passport{passport | iyr: String.to_integer(value)})
      "byr" -> check_fields(tail, %Passport{passport | byr: String.to_integer(value)})
      "eyr" -> check_fields(tail, %Passport{passport | eyr: String.to_integer(value)})
      "hgt" -> check_fields(tail, %Passport{passport | hgt: convert_to_cm(value)})
      "ecl" -> check_fields(tail, %Passport{passport | ecl: value})
      "pid" -> check_fields(tail, %Passport{passport | pid: value})
      "hcl" -> check_fields(tail, %Passport{passport | hcl: value})
      "cid" -> check_fields(tail, %Passport{passport | cid: value})
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> convert_to_passports(%Passport{})
  end

  def pid?(input) when byte_size(input) != 9, do: false
  def pid?(<<c1, c2, c3, c4, c5, c6, c7, c8, c9>>)
    when is_digit(c1)
    and  is_digit(c2)
    and  is_digit(c3)
    and  is_digit(c4)
    and  is_digit(c5)
    and  is_digit(c6)
    and  is_digit(c7)
    and  is_digit(c8)
    and  is_digit(c9), do: true
  def pid?(_),             do: false


  def hair_color?(input) when byte_size(input) != 7, do: false
  def hair_color?(<<?#, c1, c2, c3, c4, c5, c6>>)
    when is_hex(c1)
    and is_hex(c2)
    and is_hex(c3)
    and is_hex(c4)
    and is_hex(c5)
    and is_hex(c6), do: true
  def hair_color?(_),  do: false

end
