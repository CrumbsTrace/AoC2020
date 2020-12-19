Benchee.run(
  %{
    "Day19_p1" => fn input -> Day19.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day19.parse_input(Helper.get_string_from_file("inputs/Day 19/input.txt"))},
     memory_time: 1
)

Benchee.run(
  %{
    "Day19_p2" => fn input -> Day19.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day19.parse_input(Helper.get_string_from_file("inputs/Day 19/input_p2.txt"))},
     memory_time: 1
)
