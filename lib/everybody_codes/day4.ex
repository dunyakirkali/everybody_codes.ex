defmodule EverybodyCodes.Day4 do
  @doc """
      iex> "priv/day4/example1.txt" |> EverybodyCodes.Day4.input() |> EverybodyCodes.Day4.part1()
      32400

      iex> "priv/day4/example2.txt" |> EverybodyCodes.Day4.input() |> EverybodyCodes.Day4.part1()
      15888
  """
  def part1(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> a / b end)
    |> Enum.reduce(1, fn rat, acc ->
      acc * rat
    end)
    |> Kernel.*(2025)
    |> trunc()
  end

  @doc """
      iex> "priv/day4/example3.txt" |> EverybodyCodes.Day4.input() |> EverybodyCodes.Day4.part2()
      625000000000

      iex> "priv/day4/example4.txt" |> EverybodyCodes.Day4.input() |> EverybodyCodes.Day4.part2()
      1274509803922
  """
  def part2(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> a / b end)
    |> Enum.reduce(1, fn rat, acc ->
      acc * rat
    end)
    |> then(fn x ->
      10_000_000_000_000 / x
    end)
    |> Kernel.round()
  end

  @doc """
      iex> "priv/day4/example5.txt" |> EverybodyCodes.Day4.input_a() |> EverybodyCodes.Day4.part3()
      400

      iex> "priv/day4/example6.txt" |> EverybodyCodes.Day4.input_a() |> EverybodyCodes.Day4.part3()
      6818
  """
  def part3(list) do
    list
    |> List.flatten()
    |> Enum.chunk_every(2, 2, :discard)
    |> Enum.map(fn [a, b] -> a / b end)
    |> Enum.reduce(1, fn rat, acc ->
      acc * rat
    end)
    |> Kernel.*(100)
    |> trunc()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  def input_a(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "|")
      |> Enum.map(&String.to_integer(&1))
    end)
  end
end
