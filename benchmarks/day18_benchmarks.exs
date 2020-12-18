Benchee.run(
  %{
    "Day18_p1p2" => fn input -> Day18.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day18.parse_input(Helper.get_string_from_file("inputs/Day 18/input.txt"))},
     memory_time: 1
)
