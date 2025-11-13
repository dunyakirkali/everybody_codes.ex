defmodule EverybodyCodes.Day8 do
  @doc """
      iex> "priv/day8/example1.txt" |> EverybodyCodes.Day8.input() |> EverybodyCodes.Day8.part1()
      4
  """
  def part1(l) do
    len = Enum.max(l)

    l
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [f, t] -> abs(t - f) end)
    |> Enum.count(fn v -> v == Integer.floor_div(len, 2) end)
  end

  @doc """
      iex> "priv/day8/example2.txt" |> EverybodyCodes.Day8.input() |> EverybodyCodes.Day8.part2()
      21
  """
  def part2(l) do
    l
    |> Enum.chunk_every(2, 1, :discard)
    |> walk([], 0)
  end

  @doc """
      iex> "priv/day8/example3.txt" |> EverybodyCodes.Day8.input() |> EverybodyCodes.Day8.part3()
      7
  """
  def part3(l) do
    set =
      l
      |> Enum.chunk_every(2, 1, :discard)

    1..Enum.max(l)
    |> Combination.combine(2)
    |> Enum.map(fn [a, b] ->
      set
      |> Enum.count(fn [s, e] ->
        ins_min = min(s, e) < a and a < max(s, e)
        out_min = min(s, e) > a or a > max(s, e)
        ins_max = min(s, e) < b and b < max(s, e)
        out_max = min(s, e) > b or b > max(s, e)
        same = min(s, e) == min(a, b) and max(s, e) == max(a, b)

        cond do
          same -> true
          ins_min -> out_max
          ins_max -> out_min
          true -> false
        end
      end)
    end)
    |> Enum.max()
  end

  def walk([], _acc, tot), do: tot
  def walk([h | t], [], tot), do: walk(t, [h], tot)

  def walk([h | t], acc, tot) do
    [min_h, max_h] = Enum.sort(h)

    n_tot =
      acc
      |> Enum.count(fn [s, e] ->
        ins_min = min(s, e) < min_h and min_h < max(s, e)
        out_min = min(s, e) > min_h or min_h > max(s, e)
        ins_max = min(s, e) < max_h and max_h < max(s, e)
        out_max = min(s, e) > max_h or max_h > max(s, e)

        cond do
          ins_min -> out_max
          ins_max -> out_min
          true -> false
        end
      end)

    walk(t, [h | acc], tot + n_tot)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
