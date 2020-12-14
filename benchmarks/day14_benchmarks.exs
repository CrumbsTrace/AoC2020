Benchee.run(
  %{
    "Day14_p1p2" => fn input -> Day14.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day14.parse_input(Helper.get_string_from_file("inputs/Day 14/input.txt"))},
     memory_time: 1
)
