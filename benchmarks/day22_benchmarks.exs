Benchee.run(
  %{
    "Day22_p1p2" => fn input -> Day22.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day22.parse_input(Helper.get_string_from_file("inputs/Day 22/input.txt"))},
     memory_time: 1
)
