Benchee.run(
  %{
    "Day3_p1p2" => fn input -> Day3.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day3.parse_input(Helper.get_string_from_file("inputs/Day 3/input.txt"))},
     memory_time: 1
)
