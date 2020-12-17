Benchee.run(
  %{
    "Day17_p1p2" => fn input -> Day17.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day17.parse_input(Helper.get_string_from_file("inputs/Day 17/input.txt"))},
     memory_time: 1
)
