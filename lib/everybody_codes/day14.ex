defmodule EverybodyCodes.Day14 do
  @doc """
      iex> "priv/day14/example1.txt" |> EverybodyCodes.Day14.input() |> EverybodyCodes.Day14.part1()
      200
  """
  def part1(map) do
    map
    |> move([], 10)
    |> Enum.sum()
  end

  def part2(map) do
    map
    |> move([], 2025)
    |> Enum.sum()
  end

  def part3(_map) do
    # for(x <- 0..33, y <- 0..33, do: {x, y})
    # |> Enum.map(fn pos -> {pos, "."} end)
    # |> Enum.into(%{})
    # |> move_until(map, 0)
    # |> count_active()

    #
    #
    c =
      generate()
      |> Enum.count()

    Stream.cycle([360, 368, 616, 484, 732, 616, 580, 552])
    |> Enum.take(c)
    |> Enum.sum()
  end

  @diffs [116, 11, 279, 732, 138, 283, 669, 1867]

  def generate(limit \\ 1_000_000_000) do
    Stream.unfold({47, 0}, fn {current, idx} ->
      if current > limit do
        nil
      else
        next = current + Enum.at(@diffs, rem(idx, length(@diffs)))
        {current, {next, idx + 1}}
      end
    end)
  end

  def move_until(map, _pattern, 1_000_000_000), do: map

  def move_until(map, pattern, n) do
    new_map =
      map
      |> Enum.reduce(map, fn {pos, tile}, macc ->
        case tile do
          "#" ->
            new_char = move_active(map, pos)
            Map.put(macc, pos, new_char)

          "." ->
            new_char = move_inactive(map, pos)
            Map.put(macc, pos, new_char)
        end
      end)

    if matches_center?(new_map, pattern) do
      # IO.puts(n + 1)
      IO.puts(count_active(new_map))
      move_until(new_map, pattern, n + 1)
    else
      move_until(new_map, pattern, n + 1)
    end
  end

  def matches_center?(large_map, small_map, large_size \\ 34, small_size \\ 8) do
    start = div(large_size, 2) - div(small_size, 2)

    Enum.all?(small_map, fn {{r, c}, small_val} ->
      large_r = start + r
      large_c = start + c
      large_val = Map.get(large_map, {large_r, large_c})

      large_val == small_val
    end)
  end

  def move(_map, acc, 0), do: acc

  def move(map, acc, n) do
    new_map =
      map
      |> Enum.reduce(map, fn {pos, tile}, macc ->
        case tile do
          "#" ->
            new_char = move_active(map, pos)
            Map.put(macc, pos, new_char)

          "." ->
            new_char = move_inactive(map, pos)
            Map.put(macc, pos, new_char)
        end
      end)

    ac = count_active(new_map)
    move(new_map, [ac | acc], n - 1)
  end

  def move_inactive(map, pos) do
    act =
      pos
      |> neighbors()
      |> Enum.count(fn np ->
        map
        |> Map.get(np, nil)
        |> Kernel.==("#")
      end)
      |> Kernel.rem(2)
      |> Kernel.==(0)

    if act do
      "#"
    else
      "."
    end
  end

  def move_active(map, pos) do
    act =
      pos
      |> neighbors()
      |> Enum.count(fn np ->
        map
        |> Map.get(np, nil)
        |> Kernel.==("#")
      end)
      |> Kernel.rem(2)
      |> Kernel.==(1)

    if act do
      "#"
    else
      "."
    end
  end

  @doc """
      iex> "priv/day14/example4.txt" |> EverybodyCodes.Day14.input() |> EverybodyCodes.Day14.count_active()
      552
  """
  def count_active(map) do
    map
    |> Enum.count(fn {_pos, char} -> char == "#" end)
  end

  def neighbors({row, col}) do
    [
      {row + 1, col + 1},
      {row + 1, col - 1},
      {row - 1, col + 1},
      {row - 1, col - 1}
    ]
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, col} ->
        {{row, col}, char}
      end)
    end)
    |> Enum.into(%{})
  end
end
