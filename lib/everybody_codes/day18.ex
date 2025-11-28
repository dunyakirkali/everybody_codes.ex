defmodule EverybodyCodes.Day18 do
  use Memoize
  import Bitwise

  @doc """
      iex> "priv/day18/example1.txt" |> EverybodyCodes.Day18.input() |> EverybodyCodes.Day18.part1()
      774
  """
  def index_plants(l) do
    Enum.into(l, %{}, fn {p, branches} ->
      {p["plant"], {p, branches}}
    end)
  end

  def part1(l) do
    plants_map = index_plants(l)
    {last_p, _} = Enum.max_by(l, fn {p, _} -> p["plant"] end)
    energy(plants_map, last_p["plant"], [])
  end

  @doc """
      iex> "priv/day18/example2.txt" |> EverybodyCodes.Day18.input2() |> EverybodyCodes.Day18.part2()
      324
  """
  def part2({l, cases}) do
    plants_map = index_plants(l)
    {last_p, _} = Enum.max_by(l, fn {p, _} -> p["plant"] end)
    lp = last_p["plant"]

    cases
    |> Enum.map(fn case_bits ->
      energy(plants_map, lp, case_bits)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day18/example3.txt" |> EverybodyCodes.Day18.input2() |> EverybodyCodes.Day18.part3()
      946
  """
  def part3({l, cases}) do
    plants_map = index_plants(l)
    {last_p, _} = Enum.max_by(l, fn {p, _} -> p["plant"] end)
    lp = last_p["plant"]

    max =
      cases
      |> Enum.at(0)
      |> case_size()
      |> all_bits()
      |> Enum.map(fn case_bits ->
        energy(plants_map, lp, case_bits)
      end)
      |> Enum.max()
      |> IO.inspect(label: "Max energy")

    cases
    |> Enum.map(fn case_bits ->
      case energy(plants_map, lp, case_bits) do
        0 -> nil
        v -> max - v
      end
    end)
    |> Enum.filter(& &1)
    |> Enum.sum()
  end

  def all_bits(n) do
    max = (1 <<< n) - 1

    for combo <- 0..max do
      for i <- (n - 1)..0//-1, reduce: [] do
        acc ->
          bit = combo >>> i &&& 1
          [bit | acc]
      end
      |> Enum.reverse()
    end
  end

  @doc """
      iex> pm = "priv/day18/example1.txt" |> EverybodyCodes.Day18.input() |> EverybodyCodes.Day18.index_plants()
      iex> EverybodyCodes.Day18.energy(pm, 1, [])
      1

      iex> pm = "priv/day18/example1.txt" |> EverybodyCodes.Day18.input() |> EverybodyCodes.Day18.index_plants()
      iex> EverybodyCodes.Day18.energy(pm, 4, [])
      18

      iex> {old, _cases} = EverybodyCodes.Day18.input2("priv/day18/example2.txt")
      iex> pm = EverybodyCodes.Day18.index_plants(old)
      iex> EverybodyCodes.Day18.energy(pm, 1, [1, 0, 1])
      1

      iex> {old, _cases} = EverybodyCodes.Day18.input2("priv/day18/example2.txt")
      iex> pm = EverybodyCodes.Day18.index_plants(old)
      iex> EverybodyCodes.Day18.energy(pm, 4, [1, 0, 1])
      0
  """
  defmemo energy(plants_map, plant_id, case_bits \\ []) do
    {plant, branches} = Map.fetch!(plants_map, plant_id)
    plant_thickness = plant["thickness"]
    has_case = case_bits != []

    total =
      Enum.reduce(branches, 0, fn nxt, acc ->
        acc +
          case nxt do
            %{"plant" => to_plant, "thickness" => branch_thickness} ->
              energy(plants_map, to_plant, case_bits) * branch_thickness

            %{"thickness" => branch_thickness} ->
              if has_case do
                get_bit(case_bits, plant_id - 1)
              else
                branch_thickness * plant_thickness
              end
          end
      end)

    if total >= plant_thickness, do: total, else: 0
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
        |> List.to_tuple()
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

  defp get_bit(bits, idx) when is_tuple(bits), do: elem(bits, idx)
  defp get_bit(bits, idx) when is_list(bits), do: Enum.at(bits, idx)

  defp case_size(bits) when is_tuple(bits), do: tuple_size(bits)
  defp case_size(bits) when is_list(bits), do: length(bits)
end
