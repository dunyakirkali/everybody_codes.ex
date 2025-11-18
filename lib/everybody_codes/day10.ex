defmodule EverybodyCodes.Day10 do
  use Memoize

  @doc """
      iex> "priv/day10/example1.txt" |> EverybodyCodes.Day10.input() |> EverybodyCodes.Day10.part1()
      27
  """
  def part1({map, start}, iter \\ 3) do
    map
    |> move_dragon(start, [], 0, iter)
    |> Enum.uniq()
    |> Enum.count()
  end

  @doc """
      iex> "priv/day10/example3.txt" |> EverybodyCodes.Day10.input() |> EverybodyCodes.Day10.part3()
      15

      iex> "priv/day10/example4.txt" |> EverybodyCodes.Day10.input() |> EverybodyCodes.Day10.part3()
      8

      iex> "priv/day10/example5.txt" |> EverybodyCodes.Day10.input() |> EverybodyCodes.Day10.part3()
      44
  """
  def part3({map, start}) do
    sheep = map |> Enum.filter(fn {_k, v} -> v == "S" end) |> Enum.map(&elem(&1, 0))
    count(map, sheep, start, :sheep)
  end

  defmemo(count(_map, [], _dragon, :sheep), do: 1)

  defmemo count(map, sheep, dragon, :sheep) do
    {total, moved} =
      sheep
      |> Enum.with_index()
      |> Enum.reduce({0, 0}, fn {{r, c}, i}, {total, moved} ->
        cond do
          r == row_count(map) ->
            {total, moved + 1}

          Map.get(map, {r + 1, c}, "_") == "#" or
              dragon !=
                {r + 1, c} ->
            ns = List.replace_at(sheep, i, {r + 1, c})
            nt = count(map, ns, dragon, :dragon)
            {total + nt, moved + 1}

          true ->
            {total, moved}
        end
      end)

    if moved == 0 do
      count(map, sheep, dragon, :dragon)
    else
      total
    end
  end

  defmemo count(map, sheep, dragon, :dragon) do
    dragon_can_move_to(map, dragon)
    |> Enum.reduce(0, fn np, acc ->
      sheep =
        sheep
        |> Enum.filter(fn s ->
          Map.get(map, s, "_") == "#" or s != np
        end)

      acc + count(map, sheep, np, :sheep)
    end)
  end

  def row_count(map) do
    map
    |> Map.keys()
    |> Enum.map(fn {r, _c} -> r end)
    |> Enum.max()
  end

  @doc """
      iex> "priv/day10/example2.txt" |> EverybodyCodes.Day10.input() |> EverybodyCodes.Day10.part2()
      27
  """
  def part2({map, start}, iter \\ 3) do
    set =
      start
      |> List.wrap()
      |> MapSet.new()

    es = MapSet.new()

    0..(iter - 1)
    |> Enum.reduce({set, es}, fn turn, {aset, aes} ->
      aset =
        aset
        |> Enum.flat_map(fn pos ->
          dragon_can_move_to(map, pos)
        end)
        |> MapSet.new()

      aes =
        aset
        |> Enum.reduce(aes, fn {r, c}, ac ->
          [r - turn, r - turn - 1]
          |> Enum.reduce(ac, fn sr, a ->
            if Map.get(map, {r, c}, "_") != "#" and Map.get(map, {sr, c}, "_") == "S" and sr >= 0 do
              MapSet.put(a, {sr, c})
            else
              a
            end
          end)
        end)

      {aset, aes}
    end)
    |> elem(1)
    |> MapSet.size()
  end

  def move_dragon(_m, _s, acc, ci, fi) when ci == fi, do: acc

  def move_dragon(map, {r, c}, acc, i, fi) do
    dragon_can_move_to(map, {r, c})
    |> Enum.flat_map(fn np ->
      if Map.get(map, np, "_") == "S" do
        move_dragon(Map.put(map, np, "."), np, [np | acc], i + 1, fi)
      else
        move_dragon(map, np, acc, i + 1, fi)
      end
    end)
  end

  def dragon_can_move_to(map, {r, c}) do
    moves()
    |> Enum.map(fn {dr, dc} ->
      {r + dr, c + dc}
    end)
    |> Enum.filter(fn pos ->
      Map.get(map, pos, "_") == "." or Map.get(map, pos, "_") == "S" or
        Map.get(map, pos, "_") == "#"
    end)
  end

  def moves() do
    for {dr, dc} <- [{1, 2}, {2, 1}],
        {sr, sc} <- [{1, 1}, {1, -1}, {-1, 1}, {-1, -1}],
        do: {sr * dr, sc * dc}
  end

  def input(filename) do
    map =
      filename
      |> File.read!()
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, row} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, col} ->
          {{row, col}, char}
        end)
      end)
      |> Enum.into(%{})

    start = map |> Enum.find(fn {_k, v} -> v == "D" end) |> elem(0)

    {Map.put(map, start, "."), start}
  end
end
