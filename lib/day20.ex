defmodule Day20 do
  defmodule Tile do
    defstruct [:name, :edges, :edge_options, :whole_tile]
  end
  @moduledoc """
  Day 20 of Advent of Code 2020
  """

  @doc ~S"""
  ## Examples
      iex> Day20.p1p2(Day20.parse_input(Helper.get_string_from_file("inputs/Day 20/input.txt")))
      {60145080587029, 1901}
  """
  @size 144
  def p1p2(all_tiles) do
    corner_pieces = p1(all_tiles)
    p1 = corner_pieces |> Enum.reduce(1, fn {name, _}, acc -> name * acc end)
    p2 = p2(corner_pieces, all_tiles)
    {p1, p2}
  end

  def p2(corner_pieces, all_tiles) do
    {_, tile_map} = build_image(0, 0, corner_pieces |> hd() |> elem(0), get_all_edge_pairs(all_tiles), all_tiles, Map.new)
    picture = complete_picture(tile_map)
    monster_count = count_monsters(picture)
    hash_count = Enum.map(picture, fn image -> Enum.count(image, fn x -> x == "#" end) end) |> Enum.sum()
    hash_count - (15 * monster_count)
  end

  def count_monsters(image), do: all_rotations(image) |> Enum.map(&find_monster/1) |> Enum.filter( & &1 > 0) |> hd()

  def find_monster(image), do: scan_image(0, 0, Enum.map(image, fn x -> List.to_tuple(x) end) |> List.to_tuple(), 0)

  def scan_image(_, y, image, sea_monster_count) when y >= tuple_size(image), do: sea_monster_count
  def scan_image(x, y, image, sea_monster_count) when x >= tuple_size(image), do: scan_image(0, y + 1, image, sea_monster_count)
  def scan_image(x, y, image, sea_monster_count) do
    new_count = if sea_monster?(x, y, image), do: sea_monster_count + 1, else: sea_monster_count
    scan_image(x + 1, y, image, new_count)
  end

  def sea_monster?(x, y, p) do
    hash?(x, y, p)              and hash?(x + 5, y, p)      and hash?(x + 6, y, p)
    and hash?(x + 11, y, p)     and hash?(x + 12, y, p)     and hash?(x + 17, y, p)
    and hash?(x + 18, y, p)     and hash?(x + 19, y, p)     and hash?(x + 1, y - 1, p)
    and hash?(x + 4, y - 1, p)  and hash?(x + 7, y - 1, p)  and hash?(x + 10, y - 1, p)
    and hash?(x + 13, y - 1, p) and hash?(x + 16, y - 1, p) and hash?(x + 18, y + 1, p)
  end

  def hash?(x, y, picture), do: if(x < 0 or y < 0 or x >= tuple_size(picture) or y >= tuple_size(picture), do: false, else: elem(picture, y) |> elem(x) == "#")

  def complete_picture(result_map) do
    for y <- 0..round((:math.sqrt(@size) - 1)) do
      for(x <- 0..round((:math.sqrt(@size) - 1)), do: Map.fetch!(result_map, {x, y}).whole_tile |> strip_off_edges())
      |> Enum.zip()
      |> Enum.map(fn x -> (x |> Tuple.to_list() |> Enum.concat() |> Enum.reverse()) end)
    end
    |> Enum.reverse() |> Enum.concat()
  end

  def build_image(_, _, _   , _         , _        , tile_map) when map_size(tile_map) >= @size, do: {true, tile_map}
  def build_image(x, y, name, edge_pairs, all_tiles, tile_map) do
    new_edge_options = new_edge_options(edge_pairs, name, tile_map)

    Enum.find(all_tiles, fn x -> x.name == name end).edge_options
    |> try_orientations(x, y, name, edge_pairs, new_edge_options, all_tiles, tile_map)
  end

  def strip_off_edges([_|tail]), do: Enum.map(tail, fn line -> tl(line) |> Enum.reverse() |> tl() |> Enum.reverse() end) |> Enum.reverse() |> tl() |> Enum.reverse()

  def try_orientations([]         , _, _, _   , _         , _, _        ,        _), do: {false, nil}
  def try_orientations([edges|tail], x, y, name, edge_pairs, new_edge_options, all_tiles, tile_map) do
    cond do
      tile_valid?(edges, tile_map, x, y) ->
        {success, map} = try_next_edges(new_edge_options, edges, name, x, y, edge_pairs, all_tiles, tile_map)
        if success, do: {true, map}, else: try_orientations(tail, x, y, name, edge_pairs, new_edge_options, all_tiles, tile_map)

      true                               -> try_orientations(tail, x, y, name, edge_pairs, new_edge_options, all_tiles, tile_map)
    end
  end

  def new_edge_options(edge_pairs, name, tile_map) do
    Enum.filter(edge_pairs, &(name in &1))
    |> List.flatten()
    |> Enum.filter(fn next_name -> not Enum.any?(Map.values(tile_map), fn y -> y.name == next_name or y.name == name end) end)
    |> Enum.uniq()
  end

  def try_next_edges([], _, _, _, _, _, _, _), do: {false, nil}
  def try_next_edges([head|tail], edges, name, x, y, edge_pairs, all_tiles, tile_map) do
    tile = %Tile{name: name, edges: edges, whole_tile: determine_tile_rotation(edges, Enum.find(all_tiles, fn x -> x.name == name end).whole_tile)}
    {new_x, new_y} = next_xy(x, y)

    result = build_image(new_x, new_y, head, edge_pairs, all_tiles, Map.put(tile_map, {x, y}, tile))

    if elem(result, 0), do: result, else:  try_next_edges(tail, edges, name, x, y, edge_pairs, all_tiles, tile_map)
  end

  def determine_tile_rotation(edges, normal), do: all_rotations(normal) |> Enum.filter(fn x -> get_edges(x) == edges end) |> hd()

  def next_xy(x, y) do
    cond do
      rem(y, 2) == 0 and x >= :math.sqrt(@size) - 1 -> {x, y + 1}
      rem(y, 2) == 0            -> {x + 1, y}
      rem(y, 2) == 1 and x <= 0 -> {x, y + 1}
      rem(y, 2) == 1            -> {x - 1, y}
    end
  end

  def tile_valid?({_, right, bottom, left}, tile_map, x, y) do
    (if adjacent_tile = Map.get(tile_map, {x - 1, y}), do: elem(adjacent_tile.edges, 1) == left, else: true)
    and (if adjacent_tile = Map.get(tile_map, {x, y - 1}), do: elem(adjacent_tile.edges, 0) == bottom, else: true)
    and (if adjacent_tile = Map.get(tile_map, {x + 1, y}), do: elem(adjacent_tile.edges, 3) == right, else: true)
  end

  def get_all_edge_options_for_tile(normal), do: all_rotations(normal) |> Enum.map(&get_edges/1)

  def p1(all_tiles) do
    Enum.flat_map(all_tiles, &collect_edges/1)
    |> Enum.group_by( &elem(&1, 0), & elem(&1, 1))
    |> Enum.map(fn {key, value} -> {key, Enum.uniq(value)} end)
    |> Enum.filter(fn {_, value} -> Enum.count(value) == 1 end)
    |> Enum.frequencies_by(fn {_, [name]} -> name end)
    |> Enum.filter(fn {_, value} -> value == 4 end)

  end

  def get_all_edge_pairs(all_tiles) do
    Enum.flat_map(all_tiles, &collect_edges/1)
    |> Enum.group_by( &elem(&1, 0), & elem(&1, 1))
    |> Enum.map(fn {key, value} -> {key, Enum.uniq(value)} end)
    |> Enum.filter(fn {_, value} -> Enum.count(value) == 2 end)
    |> Enum.uniq_by(fn {_, [name1, name2]} -> name1 * name2 end)
    |> Enum.map(&elem(&1, 1))
  end

  def collect_edges(%Tile{name: name, whole_tile: tile}) do
    {e1, e2, e3, e4} = get_edges(tile)
    [{e1, name}, {e2, name}, {e3, name}, {e4, name}, {e1 |> Enum.reverse, name}, {e2 |> Enum.reverse, name}, {e3 |> Enum.reverse, name}, {e4 |> Enum.reverse, name}]
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.chunk_every(11) |> Enum.map(&determine_edges/1)
  end

  def determine_edges([name|pieces]) do
    pieces = Enum.map(pieces, fn x -> String.split(x, "", trim: true) end)
    name = String.split_at(name, 5) |> elem(1) |> String.replace(":", "") |> String.to_integer()
    %Tile{name: name, edge_options: get_all_edge_options_for_tile(pieces),  whole_tile: pieces}
  end

  def all_rotations(image) do
    r1 = rotate(image)
    r2 = rotate(r1)
    r3 = rotate(r2)
    flip_n_h = flip(:h, image)
    flip_n_v = flip(:v, image)
    flip_r_h2 = flip(:h, r1)
    flip_r_v2 = flip(:v, r1)
    [image, r1, r2, r3, flip_n_h, flip_n_v, flip_r_h2, flip_r_v2]
  end

  def get_edges(pieces) do
    top = hd(pieces)
    bottom = hd(pieces |> Enum.reverse)
    left = Enum.map(pieces, &hd/1)
    right = Enum.map(pieces, & Enum.reverse(&1) |> hd())
    {top, right, bottom, left}
  end

  def flip(:h, tile), do: Enum.map(tile, fn x -> Enum.reverse(x) end)
  def flip(:v, tile), do: Enum.reverse(tile)
  def rotate(tile), do: Enum.zip(tile) |> Enum.map(& &1 |> Tuple.to_list() |> Enum.reverse)

end
