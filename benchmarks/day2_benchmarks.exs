Benchee.run(
  %{
    "Day2_p1p2" => fn input -> Day2.p1p2(input) end,
  }, inputs: %{
      "Crumble Input" => Day2.parse_input(Helper.get_string_from_file("inputs/Day 2/input.txt"))}
)