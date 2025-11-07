defmodule EverybodyCodes.Day5 do
  @doc """
      iex> "priv/day5/example1.txt" |> EverybodyCodes.Day5.input() |> EverybodyCodes.Day5.part1()
      581078
  """
  def part1({_, l}) do
    do_spine(l, [])
    |> spine()
    |> Enum.join()
    |> String.to_integer()
  end

  @doc """
      iex> "priv/day5/example2.txt" |> EverybodyCodes.Day5.input_a() |> EverybodyCodes.Day5.part2()
      77053
  """
  def part2(l) do
    l
    |> Enum.map(fn s ->
      part1(s)
    end)
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
  end

  @doc """
      iex> "priv/day5/example3.txt" |> EverybodyCodes.Day5.input_a() |> EverybodyCodes.Day5.part3()
      260

      iex> "priv/day5/example4.txt" |> EverybodyCodes.Day5.input_a() |> EverybodyCodes.Day5.part3()
      4
  """
  def part3(l) do
    l
    |> Enum.map(fn {id, sword} ->
      {id, part1({id, sword}), do_spine(sword, [])}
    end)
    |> Enum.sort(fn {ida, a, sa}, {idb, b, sb} ->
      cond do
        a > b -> true
        a == b -> comp_nums({ida, sa}, {idb, sb}, 0)
        a < b -> false
      end
    end)
    |> Enum.map(fn {id, _, _} -> id end)
    |> Enum.with_index()
    |> Enum.map(fn {id, ind} -> id * (ind + 1) end)
    |> Enum.sum()
  end

  def comp_nums({il, sl}, {ir, sr}, lvl) do
    cond do
      Enum.at(sl, lvl) == nil ->
        if il > ir, do: true, else: false

      true ->
        cond do
          Enum.at(sl, lvl) |> Enum.join() |> String.to_integer() >
              Enum.at(sr, lvl) |> Enum.join() |> String.to_integer() ->
            true

          Enum.at(sl, lvl) |> Enum.join() |> String.to_integer() <
              Enum.at(sr, lvl) |> Enum.join() |> String.to_integer() ->
            false

          true ->
            comp_nums({il, sl}, {ir, sr}, lvl + 1)
        end
    end
  end

  def do_spine([], acc), do: acc
  def do_spine([h | t], []), do: do_spine(t, [[nil, h, nil]])

  def do_spine([h | t], acc) do
    acc = walk(acc, 0, h)
    do_spine(t, acc)
  end

  def walk(acc, pos, h) do
    spine = spine(acc)

    case Enum.at(spine, pos) do
      nil ->
        acc ++ [[nil, h, nil]]

      cs ->
        curr = Enum.at(acc, pos)

        cond do
          h < cs && Enum.at(curr, 0) == nil ->
            List.replace_at(acc, pos, List.replace_at(curr, 0, h))

          h > cs && Enum.at(curr, 2) == nil ->
            List.replace_at(acc, pos, List.replace_at(curr, 2, h))

          true ->
            walk(acc, pos + 1, h)
        end
    end
  end

  def spine(l) do
    l |> Enum.map(fn x -> Enum.at(x, 1) end)
  end

  def input(filename) do
    [f, b] =
      filename
      |> File.read!()
      |> String.trim()
      |> String.split(":", trim: true)

    {String.to_integer(f), String.split(b, ",", trim: true) |> Enum.map(&String.to_integer/1)}
  end

  def input_a(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [h, t] =
        line
        |> String.split(":", trim: true)

      nums =
        t
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)

      {String.to_integer(h), nums}
    end)
  end
end
