Benchee.run(
  %{
    "Day4_p1p2" => fn input -> Day4.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day4.parse_input(Helper.get_string_from_file("inputs/Day 4/input.txt"))},
     memory_time: 1
)
