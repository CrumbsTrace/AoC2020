Benchee.run(
  %{
    "Day5_p1p2" => fn input -> Day5.p1p2(input) end
  }, inputs: %{
      "Crumble Input" => String.split(Helper.get_string_from_file("inputs/Day 5/input.txt"), "\n", trim: true)},
     memory_time: 1
)
