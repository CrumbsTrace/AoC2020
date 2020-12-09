Benchee.run(
  %{
    "Day9_p1p2" => fn input -> Day9.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day9.parse_input(Helper.get_string_from_file("inputs/Day 9/input.txt"))},
     memory_time: 1
)
