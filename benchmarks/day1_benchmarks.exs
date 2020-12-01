Benchee.run(
  %{
    "Day1_p1_p2" => fn -> Day1.p1p2(Helper.get_string_from_file("Day1_input.txt")) end,
  }, memory_time: 1
)