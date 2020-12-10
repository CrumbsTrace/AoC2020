Benchee.run(
  %{
    "Day10_p1p2" => fn input -> Day10.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day10.parse_input(Helper.get_string_from_file("inputs/Day 10/input.txt"))},
     memory_time: 1
)
