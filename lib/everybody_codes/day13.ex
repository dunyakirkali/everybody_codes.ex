defmodule EverybodyCodes.Day13 do
  @doc """
      iex> "priv/day13/example1.txt" |> EverybodyCodes.Day13.input() |> EverybodyCodes.Day13.part1()
      67
  """
  def part1(map) do
    map
    |> place2([], [], :right)
    |> Stream.cycle()
    |> Enum.take(2026)
    |> List.last()
  end

  @doc """
      iex> "priv/day13/example2.txt" |> EverybodyCodes.Day13.input2() |> EverybodyCodes.Day13.part2()
      30
  """
  def part2(map) do
    map
    |> place([], [], :right)
    |> List.flatten()
    |> Stream.cycle()
    |> Enum.take(20_252_026)
    |> List.last()
  end

  @doc """
      iex> "priv/day13/example3.txt" |> EverybodyCodes.Day13.input3() |> EverybodyCodes.Day13.part3(22)
      13

      iex> "priv/day13/example3.txt" |> EverybodyCodes.Day13.input3() |> EverybodyCodes.Day13.part3(23)
      12

      iex> "priv/day13/example3.txt" |> EverybodyCodes.Day13.input3() |> EverybodyCodes.Day13.part3(24)
      1

      iex> "priv/day13/example3.txt" |> EverybodyCodes.Day13.input3() |> EverybodyCodes.Day13.part3(25)
      10
  """
  def part3(map, count \\ 202_520_252_025) do
    map
    |> place2([], [], :right)
    |> walk(count)
  end

  def walk([h | t], count) do
    cond do
      h == 1 && count == 0 ->
        1

      h == 1 ->
        walk(t ++ [h], count - 1)

      Range.size(h) <= count ->
        walk(t ++ [h], count - Range.size(h))

      Range.size(h) > count ->
        h
        |> Enum.to_list()
        |> Enum.at(count)
    end
  end

  def place([], l, r, _dir), do: [1] ++ r ++ Enum.reverse(Enum.map(l, &Enum.reverse/1))

  def place([h | t], l, r, :right) do
    place(t, l, r ++ [h], :left)
  end

  def place([h | t], l, r, :left) do
    place(t, l ++ [h], r, :right)
  end

  def place2([], l, r, _dir), do: [1] ++ r ++ Enum.reverse(l)

  def place2([h | t], l, r, :right) do
    place2(t, l, r ++ [h], :left)
  end

  def place2([h | t], l, r, :left) do
    place2(t, l ++ [h], r, :right)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def input2(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [from, to] =
        line
        |> String.split("-", trim: true)
        |> Enum.map(&String.to_integer/1)

      Range.new(from, to)
      |> Enum.to_list()
    end)
  end

  def input3(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {line, ind} ->
      [from, to] =
        line
        |> String.split("-", trim: true)
        |> Enum.map(&String.to_integer/1)

      if rem(ind, 2) == 0 do
        Range.new(from, to)
      else
        Range.new(to, from, -1)
      end
    end)
  end
end
