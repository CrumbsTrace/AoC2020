Benchee.run(
  %{
    "Day1_p1p2" => fn input -> Day1.p1p2(input) end,
    #"Short_p1_p2" => fn input -> Day1.p1p2(input) end
  }, inputs: %{ "Crumble Input" => Day1.parse_input(Helper.get_string_from_file("inputs/Day 1/My_Input.txt"))}
)

Benchee.run(
  %{
    "Day2_p1p2" => fn input -> Day2.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day2.parse_input(Helper.get_string_from_file("inputs/Day 2/input.txt"))}
)

Benchee.run(
  %{
    "Day3_p1p2" => fn input -> Day3.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day3.parse_input(Helper.get_string_from_file("inputs/Day 3/input.txt"))},
     memory_time: 1
)

Benchee.run(
  %{
    "Day4_p1p2" => fn input -> Day4.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day4.parse_input(Helper.get_string_from_file("inputs/Day 4/input.txt"))},
     memory_time: 1
)

Benchee.run(
  %{
    "Day5_p1p2" => fn input -> Day5.p1p2(input) end
  }, inputs: %{
      "Crumble Input" => String.split(Helper.get_string_from_file("inputs/Day 5/input.txt"), "\n", trim: true)},
     memory_time: 1
)
