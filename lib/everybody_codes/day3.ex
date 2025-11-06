defmodule EverybodyCodes.Day3 do
  @doc """
      iex> "priv/day3/example1.txt" |> EverybodyCodes.Day3.input() |> EverybodyCodes.Day3.part1()
      29
  """
  def part1(list) do
    list
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.reduce([], fn item, acc ->
      case acc do
        [] ->
          [item]

        [head | _tail] ->
          if head > item do
            [item | acc]
          else
            acc
          end
      end
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day3/example2.txt" |> EverybodyCodes.Day3.input() |> EverybodyCodes.Day3.part2()
      781
  """
  def part2(list) do
    list
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.sort()
    |> Enum.take(20)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day3/example3.txt" |> EverybodyCodes.Day3.input() |> EverybodyCodes.Day3.part3()
      3
  """
  def part3(list) do
    list
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.max()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end
end
