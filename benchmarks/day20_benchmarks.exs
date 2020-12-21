Benchee.run(
  %{
    "Day20_p1p2" => fn input -> Day20.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day20.parse_input(Helper.get_string_from_file("inputs/Day 20/input.txt"))},
     memory_time: 1
)
