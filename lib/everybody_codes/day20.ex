defmodule EverybodyCodes.Day20 do
  use Memoize

  @doc """
      iex> "priv/day20/example1.txt" |> EverybodyCodes.Day20.input() |> EverybodyCodes.Day20.part1()
      24
  """
  def part1(l) do
    l
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
