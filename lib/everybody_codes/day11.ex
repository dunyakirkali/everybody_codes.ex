defmodule EverybodyCodes.Day11 do
  @doc """
      iex> "priv/day11/example3.txt" |> EverybodyCodes.Day11.input() |> EverybodyCodes.Day11.part3()
      1378
  """
  def part3(map) do
    # Convert map to tuple for faster indexed access
    arr = map_to_tuple(map)

    avg = Enum.sum(Tuple.to_list(arr)) |> div(tuple_size(arr))

    Enum.map(Tuple.to_list(arr), fn x -> abs(x - avg) end)
    |> Enum.sum()
    |> Kernel.div(2)
  end

  @doc """
      iex> "priv/day11/example2.txt" |> EverybodyCodes.Day11.input() |> EverybodyCodes.Day11.part2()
      11

      iex> "priv/day11/example3.txt" |> EverybodyCodes.Day11.input() |> EverybodyCodes.Day11.part2()
      1579
  """
  def part2(map) do
    # Convert map to tuple for faster indexed access
    arr = map_to_tuple(map)
    size = tuple_size(arr)

    # Phase one: move right until stable
    {p1, step} = phase_one_until_stable(arr, size, 0)

    # Phase two: move left until all same or stable
    phase_two_until_done(p1, size, step)
  end

  @doc """
      iex> "priv/day11/example1.txt" |> EverybodyCodes.Day11.input() |> EverybodyCodes.Day11.part1()
      109
  """
  def part1(map) do
    cap = 10
    arr = map_to_tuple(map)
    size = tuple_size(arr)

    {p1, step} = phase_one_until_stable(arr, size, 0)
    p2 = phase_two_n_times(p1, size, cap - step)

    checksum_tuple(p2)
  end

  defp map_to_tuple(map) do
    0..(map_size(map) - 1)
    |> Enum.map(&Map.get(map, &1))
    |> List.to_tuple()
  end

  defp checksum_tuple(arr) do
    arr
    |> Tuple.to_list()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {v, i}, acc -> acc + v * i end)
  end

  defp phase_one_until_stable(arr, size, step) do
    new_arr = do_phase_one(arr, size, 0, arr)

    if new_arr == arr do
      {arr, step}
    else
      phase_one_until_stable(new_arr, size, step + 1)
    end
  end

  defp do_phase_one(_arr, size, i, acc) when i >= size - 1, do: acc

  defp do_phase_one(arr, size, i, acc) do
    curr = elem(acc, i)
    next = elem(acc, i + 1)

    new_acc =
      if curr > next do
        acc
        |> put_elem(i, curr - 1)
        |> put_elem(i + 1, next + 1)
      else
        acc
      end

    do_phase_one(arr, size, i + 1, new_acc)
  end

  defp phase_two_until_done(arr, size, step) do
    new_arr = do_phase_two(arr, size, 0, arr)

    cond do
      all_same_tuple?(new_arr, size) ->
        step + 1

      new_arr == arr ->
        step

      true ->
        phase_two_until_done(new_arr, size, step + 1)
    end
  end

  defp phase_two_n_times(arr, _size, 0), do: arr

  defp phase_two_n_times(arr, size, n) do
    new_arr = do_phase_two(arr, size, 0, arr)

    if new_arr == arr do
      arr
    else
      phase_two_n_times(new_arr, size, n - 1)
    end
  end

  defp do_phase_two(_arr, size, i, acc) when i >= size - 1, do: acc

  defp do_phase_two(arr, size, i, acc) do
    curr = elem(acc, i)
    next = elem(acc, i + 1)

    new_acc =
      if curr < next do
        acc
        |> put_elem(i + 1, next - 1)
        |> put_elem(i, curr + 1)
      else
        acc
      end

    do_phase_two(arr, size, i + 1, new_acc)
  end

  defp all_same_tuple?(arr, size) do
    first = elem(arr, 0)
    all_same_tuple?(arr, size, 1, first)
  end

  defp all_same_tuple?(_arr, size, i, _first) when i >= size, do: true

  defp all_same_tuple?(arr, size, i, first) do
    if elem(arr, i) == first do
      all_same_tuple?(arr, size, i + 1, first)
    else
      false
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {n, i}, acc -> Map.put(acc, i, n) end)
  end
end
