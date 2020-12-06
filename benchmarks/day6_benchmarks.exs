Benchee.run(
  %{
    "Day6_p1p2" => fn input -> Day6.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day6.parse_input(Helper.get_string_from_file("inputs/Day 6/input.txt"))},
     memory_time: 1
)
