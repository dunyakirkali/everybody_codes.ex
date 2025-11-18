defmodule EverybodyCodes.Day12 do
  @doc """
      iex> "priv/day12/example1.txt" |> EverybodyCodes.Day12.input() |> EverybodyCodes.Day12.part1()
      16
  """
  def part1(map) do
    map
    |> ignite({0, 0}, MapSet.new())
    |> MapSet.size()
  end

  @doc """
      iex> "priv/day12/example2.txt" |> EverybodyCodes.Day12.input() |> EverybodyCodes.Day12.part2()
      58
  """
  def part2(map) do
    a = ignite(map, {0, 0}, MapSet.new())

    mx = map |> Map.keys() |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    my = map |> Map.keys() |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    b = ignite(map, {mx, my}, MapSet.new())

    MapSet.union(a, b)
    |> MapSet.size()
  end

  @doc """
      iex> "priv/day12/example3.txt" |> EverybodyCodes.Day12.input() |> EverybodyCodes.Day12.part3()
      14

      iex> "priv/day12/example4.txt" |> EverybodyCodes.Day12.input() |> EverybodyCodes.Day12.part3()
      133
  """
  def part3(map) do
    first =
      map
      |> Map.keys()
      |> Enum.map(fn pos ->
        ignite_with_order(map, pos, MapSet.new(), [])
      end)
      |> Enum.max_by(fn {_set, list} -> length(list) end)

    {first_set, first_list} = first

    second =
      map
      |> Map.keys()
      |> Enum.map(fn pos ->
        ignite_with_order(map, pos, first_set, [])
      end)
      |> Enum.max_by(fn {_set, list} -> length(list) end)

    {second_set, second_list} = second

    third =
      map
      |> Map.keys()
      |> Enum.map(fn pos ->
        ignite_with_order(map, pos, MapSet.union(first_set, second_set), [])
      end)
      |> Enum.max_by(fn {_set, list} -> length(list) end)

    {_third_set, third_list} = third

    a = ignite(map, List.last(first_list), MapSet.new())
    b = ignite(map, List.last(second_list), MapSet.new())
    c = ignite(map, List.last(third_list), MapSet.new())

    MapSet.union(a, b)
    |> MapSet.union(c)
    |> MapSet.size()
  end

  def ignite(map, pos, visited) do
    new_visited = MapSet.put(visited, pos)

    pos
    |> neighbors()
    |> Enum.filter(&Map.has_key?(map, &1))
    |> Enum.filter(fn n -> not MapSet.member?(new_visited, n) end)
    |> Enum.filter(fn n -> Map.get(map, n) <= Map.get(map, pos) end)
    |> Enum.reduce(new_visited, fn n, acc ->
      ignite(map, n, acc)
    end)
  end

  # Version that also tracks order for part3
  defp ignite_with_order(map, pos, visited, order_list) do
    new_visited = MapSet.put(visited, pos)
    new_order = [pos | order_list]

    pos
    |> neighbors()
    |> Enum.filter(&Map.has_key?(map, &1))
    |> Enum.filter(fn n -> not MapSet.member?(new_visited, n) end)
    |> Enum.filter(fn n -> Map.get(map, n) <= Map.get(map, pos) end)
    |> Enum.reduce({new_visited, new_order}, fn n, {v_acc, o_acc} ->
      ignite_with_order(map, n, v_acc, o_acc)
    end)
  end

  def neighbors({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> {{x, y}, String.to_integer(char)} end)
    end)
    |> Enum.into(%{})
  end
end
