Benchee.run(
  %{
    "Day1_p1p2" => fn input -> Day1.p1p2(input) end,
    #"Short_p1_p2" => fn input -> Day1.p1p2(input) end
  }, inputs: %{
      "Crumble Input" => Day1.parse_input(Helper.get_string_from_file("inputs/Day 1/My_Input.txt")),
      "Cat Input" => Day1.parse_input(Helper.get_string_from_file("inputs/Day 1/Cat_Input.txt")),
      "Mousey Input" => Day1.parse_input(Helper.get_string_from_file("inputs/Day 1/Mousey_Input.txt")),
      "Aquo input" => Day1.parse_input(Helper.get_string_from_file("inputs/Day 1/Aquo_Input.txt"))},
    memory_time: 1
)