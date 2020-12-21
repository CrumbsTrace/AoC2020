defmodule Day21 do
  @moduledoc """
  Day 21 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day21.p1p2(Day21.parse_input(Helper.get_string_from_file("inputs/Day 21/input.txt")))
      {1882, "xgtj,ztdctgq,bdnrnx,cdvjp,jdggtft,mdbq,rmd,lgllb"}

  """
  def p1p2({alg_info, ingredient_mapset}) do
    p1 = p1(alg_info, ingredient_mapset)
    p2 = p2(alg_info)
    {p1, p2}
  end

  def p1(alg_info, ingredient_mapset) do
    ingrs_with_possible_alg = List.flatten(Map.values(alg_info)) |> Enum.uniq()
    Enum.reject(ingredient_mapset, fn x -> x in ingrs_with_possible_alg end) |> Enum.count()
  end

  def p2(alg_info) do
    if Enum.any?(Map.values(alg_info), fn x -> Enum.count(x) > 1 end) do
      known = Enum.filter(Map.values(alg_info), fn x -> Enum.count(x) == 1 end) |> List.flatten
      alg_info |> Enum.map(fn {alg, ingrs} ->  update_alg_map(alg, ingrs, known) end) |> Map.new() |> p2()
    else
      alg_info |> Enum.sort_by(fn {alg, _} -> alg end) |> Enum.flat_map(fn {_, ingredient} -> ingredient end) |> Enum.join(",")
    end
  end

  def update_alg_map(alg, ingr, known), do: if(Enum.count(ingr) == 1, do: {alg, ingr}, else: {alg, Enum.reject(ingr, & &1 in known)})

  def parse_input(input), do: input |> split("\n") |> Enum.map(&split(&1, ["(contains", ")"])) |> Enum.reduce({Map.new, []}, & add_ingrs(&1, &2))

  def add_ingrs([line_ingrs, algs], {map, ingrs}) do
    {algs, line_ingrs} = {split(algs, [" ", ","]), split(line_ingrs, " ")}
    {Enum.reduce(algs, map, &update_alg(&1, line_ingrs, &2)), Enum.reduce(line_ingrs, ingrs, &[&1|&2])}
  end

  def update_alg(_       , []        , map), do: map
  def update_alg(alg, ingrs, map), do: if(Map.has_key?(map, alg), do: Map.update!(map, alg, fn list -> Enum.filter(list, & (&1 in ingrs)) end), else: Map.put(map, alg, ingrs))

  def split(input, pattern), do: String.split(input, pattern, trim: true)
end
