defmodule EverybodyCodes.Day2 do
  @doc """
      iex> "priv/day2/example1.txt" |> EverybodyCodes.Day2.input() |> EverybodyCodes.Day2.part1()
      [357,862]
  """
  def part1([x, y]) do
    1..3
    |> Enum.reduce({{0, 0}, {x, y}}, fn _step, {r, a} ->
      {r, a}
      r = mu(r, r)
      r = di(r, 10)
      r = ad(r, a)
      {r, a}
    end)
    |> elem(0)
    |> Tuple.to_list()
  end

  @doc """
      iex> "priv/day2/example2.txt" |> EverybodyCodes.Day2.input() |> EverybodyCodes.Day2.part2()
      4076
  """
  def part2([x, y]) do
    for(i <- x..(x + 1000)//10, j <- y..(y + 1000)//10, do: {i, j})
    |> Enum.map(fn point ->
      1..100
      |> Enum.reduce_while({{0, 0}, point}, fn _step, {r, a} ->
        r = mu(r, r)
        r = di(r, 100_000)
        r = ad(r, a)
        {rx, ry} = r

        cond do
          rx > 1_000_000 -> {:halt, nil}
          ry > 1_000_000 -> {:halt, nil}
          rx < -1_000_000 -> {:halt, nil}
          ry < -1_000_000 -> {:halt, nil}
          true -> {:cont, {r, a}}
        end
      end)
    end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  @doc """
      iex> "priv/day2/example3.txt" |> EverybodyCodes.Day2.input() |> EverybodyCodes.Day2.part3()
      406954
  """
  def part3([x, y]) do
    for(i <- x..(x + 1000), j <- y..(y + 1000), do: {i, j})
    |> Enum.map(fn point ->
      1..100
      |> Enum.reduce_while({{0, 0}, point}, fn _step, {r, a} ->
        r = mu(r, r)
        r = di(r, 100_000)
        r = ad(r, a)
        {rx, ry} = r

        cond do
          rx > 1_000_000 -> {:halt, nil}
          ry > 1_000_000 -> {:halt, nil}
          rx < -1_000_000 -> {:halt, nil}
          ry < -1_000_000 -> {:halt, nil}
          true -> {:cont, {r, a}}
        end
      end)
    end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  defp mu({x1, y1}, {x2, y2}) do
    {
      x1 * x2 - y1 * y2,
      x1 * y2 + y1 * x2
    }
  end

  defp ad({x1, y1}, {x2, y2}) do
    {
      x1 + x2,
      y1 + y2
    }
  end

  def di({x, y}, n) do
    {
      trunc(x / n),
      trunc(y / n)
    }
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("[")
    |> List.last()
    |> String.split("]")
    |> List.first()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end
end
