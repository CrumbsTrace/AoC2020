Benchee.run(
  %{
    "Day16_p1p2" => fn input -> Day16.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day16.parse_input(Helper.get_string_from_file("inputs/Day 16/input.txt"))},
     memory_time: 1
)
