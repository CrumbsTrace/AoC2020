Benchee.run(
  %{
    "Day8_p1p2" => fn input -> Day8.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day8.parse_input("inputs/Day 8/input.txt")},
     memory_time: 1
)
