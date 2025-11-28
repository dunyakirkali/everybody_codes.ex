defmodule EverybodyCodes.Day18 do
  use Memoize

  @doc """
      iex> "priv/day18/example1.txt" |> EverybodyCodes.Day18.input() |> EverybodyCodes.Day18.part1()
      774
  """
  def part1(l) do
    last_plant = List.last(l)

    energy(l, last_plant)
  end

  @doc """
      iex> "priv/day18/example2.txt" |> EverybodyCodes.Day18.input2() |> EverybodyCodes.Day18.part2()
      324
  """
  def part2({l, cases}) do
    last_plant =
      l
      |> Enum.max_by(fn {p, _} -> p["plant"] end)

    cases
    |> Enum.map(fn case ->
      energy(l, last_plant, case)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day18/example3.txt" |> EverybodyCodes.Day18.input2() |> EverybodyCodes.Day18.part3()
      946
  """
  def part3({l, cases}) do
    last_plant =
      l
      |> Enum.max_by(fn {p, _} -> p["plant"] end)

    max =
      cases
      |> Enum.at(0)
      |> length()
      |> all_bits()
      |> Enum.map(fn case ->
        energy(l, last_plant, case)
      end)
      |> Enum.max()

    cases
    |> Enum.map(fn case ->
      case energy(l, last_plant, case) do
        0 -> nil
        v -> max - v
      end
    end)
    |> Enum.filter(& &1)
    |> Enum.sum()
  end

  def all_bits(n) do
    for combo <- 0..((:math.pow(2, n) |> round) - 1) do
      Integer.digits(combo, 2)
      |> pad_left(n)
    end
  end

  defp pad_left(list, n) do
    List.duplicate(0, n - length(list)) ++ list
  end

  @doc """
      iex> "priv/day18/example1.txt" |> EverybodyCodes.Day18.input() |> EverybodyCodes.Day18.energy({%{"plant" => 1, "thickness" => 1}, [%{"thickness" => 1}]})
      1

      iex> "priv/day18/example1.txt" |> EverybodyCodes.Day18.input() |> EverybodyCodes.Day18.energy({%{"plant" => 4, "thickness" => 17}, [%{"plant" => 1, "thickness" => 15}, %{"plant" => 2, "thickness" => 3}]})
      18

      iex> "priv/day18/example2.txt" |> EverybodyCodes.Day18.input2() |> elem(0) |> EverybodyCodes.Day18.energy({%{"plant" => 1, "thickness" => 1}, [%{"thickness" => 1}]}, [1, 0, 1])
      1

      iex> "priv/day18/example2.txt" |> EverybodyCodes.Day18.input2() |> elem(0) |> EverybodyCodes.Day18.energy({%{"plant" => 4, "thickness" => 10},[%{"plant" => 1, "thickness" => -25},%{"plant" => 2, "thickness" => 17},%{"plant" => 3, "thickness" => 12}]}, [1, 0, 1])
      0
  """
  defmemo energy(
            plants,
            {%{"plant" => plant, "thickness" => plant_thickness}, branches},
            case \\ []
          ) do
    branches
    |> Enum.map(fn nxt ->
      case nxt do
        %{"plant" => to_plant, "thickness" => branch_thickness} ->
          to_plant =
            Enum.find(plants, fn {p, _} -> p["plant"] == to_plant end)

          energy(plants, to_plant, case) * branch_thickness

        %{"thickness" => branch_thickness} ->
          if length(case) == 0 do
            branch_thickness * plant_thickness
          else
            Enum.at(case, plant - 1)
          end
      end
    end)
    |> Enum.sum()
    |> then(fn energy ->
      if energy >= plant_thickness do
        energy
      else
        0
      end
    end)
  end

  def input2(filename) do
    [old, new] =
      filename
      |> File.read!()
      |> String.split("\n\n\n", trim: true)

    {
      old
      |> parse_plants(),
      new
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
    }
  end

  def input(filename) do
    filename
    |> File.read!()
    |> parse_plants()
  end

  def parse_plants(data) do
    data
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn group ->
      [h | r] = String.split(group, "\n", trim: true)

      plants =
        Regex.named_captures(~r/Plant (?<plant>\d+) with thickness (?<thickness>\d+):/, h)
        |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
        |> Enum.into(%{})

      branches =
        r
        |> Enum.map(fn line ->
          if String.starts_with?(line, "- free") do
            Regex.named_captures(~r/- free branch with thickness (?<thickness>-?\d+)/, line)
            |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
            |> Enum.into(%{})
          else
            Regex.named_captures(
              ~r/branch to Plant (?<plant>\d+) with thickness (?<thickness>-?\d+)/,
              line
            )
            |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
            |> Enum.into(%{})
          end
        end)

      {plants, branches}
    end)
  end
end
