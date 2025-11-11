defmodule EverybodyCodes.Day6 do
  @doc """
      iex> "priv/day6/example1.txt" |> EverybodyCodes.Day6.input() |> EverybodyCodes.Day6.part1()
      5
  """
  def part1(l) do
    l
    |> Enum.filter(fn i -> i == "A" or i == "a" end)
    |> walk(0, 0, ?A)
  end

  @doc """
      iex> "priv/day6/example2.txt" |> EverybodyCodes.Day6.input() |> EverybodyCodes.Day6.part2()
      11
  """
  def part2(l) do
    ?A..?Z
    |> Enum.map(fn letter ->
      l
      |> Enum.filter(fn i -> i == <<letter>> or i == String.downcase(<<letter>>) end)
      |> walk(0, 0, letter)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day6/example3.txt" |> EverybodyCodes.Day6.input() |> EverybodyCodes.Day6.part3()
      34

      iex> "priv/day6/example4.txt" |> EverybodyCodes.Day6.input() |> EverybodyCodes.Day6.part3(10, 2)
      72

      ex> "priv/day6/example5.txt" |> EverybodyCodes.Day6.input() |> EverybodyCodes.Day6.part3(1000, 1000)
      3442321
  """
  def part3(l, size \\ 10, repeat \\ 1) do
    for(_ <- 1..repeat, do: l)
    |> List.flatten()
    |> Enum.join("")
    |> String.to_charlist()
    |> walk_2(0, [], size)
  end

  def walk_2([], acc, _rest, _size), do: acc

  def walk_2([h | t], acc, rest, size) do
    aft = Enum.take(t, size)
    bef = Enum.take(rest, size)

    cond do
      Enum.member?(?a..?z, h) ->
        c_aft =
          Enum.count(aft, fn i -> h - 32 == i end)

        c_bef =
          Enum.count(bef, fn i -> h - 32 == i end)

        walk_2(t, acc + c_aft + c_bef, Enum.take([h | rest], size), size)

      true ->
        walk_2(t, acc, Enum.take([h | rest], size), size)
    end
  end

  def walk([], _mentor_count, pairs, _letter), do: pairs

  def walk([h | t], mentor_count, pairs, letter) do
    cond do
      h == <<letter>> ->
        walk(t, mentor_count + 1, pairs, letter)

      h == String.downcase(<<letter>>) ->
        walk(t, mentor_count, pairs + mentor_count, letter)

      true ->
        walk(t, mentor_count, pairs, letter)
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("", trim: true)
  end
end
