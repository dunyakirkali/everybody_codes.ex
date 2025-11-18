defmodule EverybodyCodes.Day9 do
  @doc """
      iex> "priv/day9/example1.txt" |> EverybodyCodes.Day9.input() |> EverybodyCodes.Day9.part1()
      414
  """
  def part1(%{1 => g1, 2 => g2, 3 => g3}) do
    first = find_child(g1, g2, g3)
    second = find_child(g2, g3, g1)
    third = find_child(g3, g1, g2)

    cond do
      first -> comp(g1, g2) * comp(g1, g3)
      second -> comp(g2, g1) * comp(g2, g3)
      third -> comp(g3, g1) * comp(g3, g2)
    end
  end

  @doc """
      iex> "priv/day9/example2.txt" |> EverybodyCodes.Day9.input() |> EverybodyCodes.Day9.part2()
      1245
  """
  def part2(hash) do
    hash
    |> Map.keys()
    |> Combination.combine(3)
    |> Enum.reduce([], fn [i1, i2, i3], acc ->
      g1 = Map.get(hash, i1)
      g2 = Map.get(hash, i2)
      g3 = Map.get(hash, i3)

      cond do
        find_child(g1, g2, g3) -> [[i1, i2, i3] | acc]
        find_child(g2, g3, g1) -> [[i2, i3, i1] | acc]
        find_child(g3, g1, g2) -> [[i3, i1, i2] | acc]
        true -> acc
      end
    end)
    |> Enum.uniq_by(fn [head | _] -> head end)
    |> Enum.map(fn [i1, i2, i3] ->
      g1 = Map.get(hash, i1)
      g2 = Map.get(hash, i2)
      g3 = Map.get(hash, i3)

      comp(g1, g2) * comp(g1, g3)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day9/example3.txt" |> EverybodyCodes.Day9.input() |> EverybodyCodes.Day9.part3()
      12

      iex> "priv/day9/example4.txt" |> EverybodyCodes.Day9.input() |> EverybodyCodes.Day9.part3()
      36
  """
  def part3(hash) do
    hash
    |> Map.keys()
    |> Combination.combine(3)
    |> Enum.reduce([], fn [i1, i2, i3], acc ->
      g1 = Map.get(hash, i1)
      g2 = Map.get(hash, i2)
      g3 = Map.get(hash, i3)

      cond do
        find_child(g1, g2, g3) -> [[i1, i2, i3] | acc]
        find_child(g2, g3, g1) -> [[i2, i3, i1] | acc]
        find_child(g3, g1, g2) -> [[i3, i1, i2] | acc]
        true -> acc
      end
    end)
    |> Enum.uniq_by(fn [head | _] -> head end)
    |> IO.inspect()
    |> then(fn fams ->
      fam =
        fams
        |> Enum.map(fn [_, a, b] -> {a, b} end)
        |> Enum.frequencies()
        |> Enum.max_by(fn {_key, value} -> value end)
        |> elem(0)

      fams
      |> Enum.filter(fn [_, a, b] ->
        (a == elem(fam, 0) and b == elem(fam, 1)) or (a == elem(fam, 1) and b == elem(fam, 0))
      end)
      |> List.flatten()
      |> MapSet.new()
      |> Enum.sum()
    end)
  end

  def find_child(g1, g2, g3) do
    find_child_helper(g1, g2, g3)
  end

  defp find_child_helper([c1 | rest1], [c2 | rest2], [c3 | rest3]) do
    (c1 == c2 or c1 == c3) and find_child_helper(rest1, rest2, rest3)
  end

  defp find_child_helper([], [], []), do: true

  @doc """
      iex> EverybodyCodes.Day9.comp(~c"CATG", ~c"CATA")
      3
  """
  def comp(l, r) do
    comp_helper(l, r, 0)
  end

  defp comp_helper([a | rest1], [a | rest2], count) do
    comp_helper(rest1, rest2, count + 1)
  end

  defp comp_helper([_ | rest1], [_ | rest2], count) do
    comp_helper(rest1, rest2, count)
  end

  defp comp_helper([], [], count), do: count

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn ilne ->
      [id, genes] =
        ilne
        |> String.split(":", trim: true)

      {String.to_integer(id), to_charlist(genes)}
    end)
    |> Enum.into(%{})
  end
end
