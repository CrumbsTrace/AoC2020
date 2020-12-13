Benchee.run(
  %{
    "Day13_p1p2" => fn input -> Day13.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day13.parse_input(Helper.get_string_from_file("inputs/Day 13/input.txt"))},
     memory_time: 1
)
