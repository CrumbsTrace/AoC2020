Benchee.run(
  %{
    "Day24_p1p2" => fn input -> Day24.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day24.parse_input(Helper.get_string_from_file("inputs/Day 24/input.txt"))},
     memory_time: 1
)
