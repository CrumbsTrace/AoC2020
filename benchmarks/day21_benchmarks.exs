Benchee.run(
  %{
    "Day21_p1p2" => fn input -> Day21.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day21.parse_input(Helper.get_string_from_file("inputs/Day 21/input.txt"))},
     memory_time: 1
)
