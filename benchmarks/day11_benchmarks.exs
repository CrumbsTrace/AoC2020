Benchee.run(
  %{
    "Day11_p1p2" => fn input -> Day11.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day11.parse_input(Helper.get_string_from_file("inputs/Day 11/input.txt"))},
     memory_time: 1
)
