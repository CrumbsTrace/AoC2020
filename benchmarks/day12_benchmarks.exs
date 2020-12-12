Benchee.run(
  %{
    "Day12_p1p2" => fn input -> Day12.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day12.parse_input(Helper.get_string_from_file("inputs/Day 12/input.txt"))},
     memory_time: 1
)
