defmodule EverybodyCodes.Day19 do
  use Memoize

  @doc """
      iex> "priv/day19/example1.txt" |> EverybodyCodes.Day19.input() |> EverybodyCodes.Day19.part1()
      24
  """
  def part1(l) do
    map = l |> make_map()

    dest =
      l
      |> List.last()
      |> Enum.take(2)
      |> List.to_tuple()

    solve(map, dest)
  end

  @doc """
      iex> "priv/day19/example2.txt" |> EverybodyCodes.Day19.input() |> EverybodyCodes.Day19.part2()
      22
  """
  def part2(l) do
    map = l |> make_map()

    dest =
      l
      |> List.last()
      |> Enum.take(2)
      |> List.to_tuple()

    solve(map, dest)
  end

  def solve(map, dest) do
    dest_x = elem(dest, 0)

    cols =
      map
      |> Map.keys()
      |> Enum.filter(&(&1 <= dest_x))
      |> Enum.sort()

    res =
      Enum.reduce_while(cols, 0, fn a, u_min ->
        intervals = map |> Map.get(a) |> to_intervals()

        base_lo = ceil_div(a, 2)

        u_ranges =
          intervals
          |> Enum.map(fn {l, r} ->
            lo = max(base_lo, ceil_div(a + l, 2))
            hi = floor_div(a + r, 2)
            {lo, hi}
          end)
          |> Enum.filter(fn {lo, hi} -> lo <= hi end)

        if u_ranges == [] do
          {:halt, :no_path}
        else
          max_hi =
            u_ranges
            |> Enum.map(fn {_, hi} -> hi end)
            |> Enum.max()

          if u_min > max_hi do
            {:halt, :no_path}
          else
            candidate =
              u_ranges
              |> Enum.filter(fn {_, hi} -> hi >= u_min end)
              |> Enum.map(fn {lo, _hi} -> max(u_min, lo) end)
              |> Enum.min()

            {:cont, candidate}
          end
        end
      end)

    case res do
      :no_path ->
        :no_path

      u_min_final ->
        base = ceil_div(dest_x, 2)
        max(u_min_final, base)
    end
  end

  def to_intervals(gaps) do
    gaps
    |> Enum.map(fn [_, y, delta] -> {y, y + delta + 1} end)
    |> Enum.sort()
    |> merge_intervals()
  end

  def merge_intervals(sorted) do
    Enum.reduce(sorted, [], fn {l, r}, acc ->
      case acc do
        [] ->
          [{l, r}]

        [{al, ar} | rest] ->
          if l <= ar + 1 do
            [{al, max(ar, r)} | rest]
          else
            [{l, r} | acc]
          end
      end
    end)
    |> Enum.reverse()
  end

  def ceil_div(a, b), do: div(a + b - 1, b)
  def floor_div(a, b), do: div(a, b)

  def options({x, y}) do
    [
      {:down, {x + 1, y - 1}},
      {:up, {x + 1, y + 1}}
    ]
  end

  def make_map(l) do
    l
    |> Enum.group_by(fn [a, _, _] ->
      a
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
