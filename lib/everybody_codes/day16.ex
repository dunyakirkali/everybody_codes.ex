defmodule EverybodyCodes.Day16 do
  @doc """
      iex> "priv/day16/example1.txt" |> EverybodyCodes.Day16.input() |> EverybodyCodes.Day16.part1()
      193
  """
  def part1(l) do
    l
    |> walls()
    |> Map.values()
    |> Enum.sum()
  end

  def walls(l, len \\ 90) do
    wall = for i <- 0..(len - 1), do: {i, 0}, into: %{}

    l
    |> Enum.reduce(wall, fn step, walll ->
      (step - 1)..(len - 1)//step
      |> Enum.reduce(walll, fn x, wallll ->
        Map.update!(wallll, x, &(&1 + 1))
      end)
    end)
  end

  @doc """
      iex> "priv/day16/example2.txt" |> EverybodyCodes.Day16.input() |> EverybodyCodes.Day16.part2()
      270
  """
  def part2(l) do
    len = length(l)

    find(l, [], len)
    |> Enum.reduce(1, fn x, acc -> acc * x end)
  end

  @doc """
      iex> "priv/day16/example3.txt" |> EverybodyCodes.Day16.input() |> EverybodyCodes.Day16.part3(100)
      47

      iex> "priv/day16/example3.txt" |> EverybodyCodes.Day16.input() |> EverybodyCodes.Day16.part3(1000)
      467

      iex> "priv/day16/example3.txt" |> EverybodyCodes.Day16.input() |> EverybodyCodes.Day16.part3(10000)
      4664

      iex> "priv/day16/example3.txt" |> EverybodyCodes.Day16.input() |> EverybodyCodes.Day16.part3(100000)
      46633

      iex> "priv/day16/example3.txt" |> EverybodyCodes.Day16.input() |> EverybodyCodes.Day16.part3(1000000)
      466322

      iex> "priv/day16/example3.txt" |> EverybodyCodes.Day16.input() |> EverybodyCodes.Day16.part3(10000000)
      4663213
  """
  def part3(l, blocks \\ 202_520_252_025_000) do
    len = length(l)
    rule = find(l, [], len)
    binary_search(0, blocks, rule, blocks)
  end

  def binary_search(low, high, _rule, _blocks) when low >= high, do: low

  def binary_search(low, high, rule, blocks) do
    mid = div(low + high, 2)
    cb = count_blocks(mid, rule)

    cond do
      cb == blocks -> mid
      cb > blocks -> binary_search(low, mid - 1, rule, blocks)
      cb < blocks -> binary_search(mid + 1, high, rule, blocks)
    end
  end

  @doc """
      iex> EverybodyCodes.Day16.count_blocks(90, [1, 2, 3, 5, 9])
      193
  """
  def count_blocks(wall_length, pattern) do
    for(value <- pattern, do: div(wall_length, value))
    |> Enum.sum()
  end

  def find(l, acc, len) do
    if Enum.sum(l) == 0 do
      Enum.reverse(acc)
    else
      index = Enum.find_index(l, fn x -> x != 0 end)

      iter =
        [index + 1]
        |> walls(len)
        |> Enum.sort_by(fn {k, _v} -> k end)
        |> Enum.map(fn {_k, v} -> v end)

      nl =
        l
        |> Enum.with_index()
        |> Enum.map(fn {step, idx} ->
          step - Enum.at(iter, idx)
        end)

      find(nl, [index + 1 | acc], len)
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
