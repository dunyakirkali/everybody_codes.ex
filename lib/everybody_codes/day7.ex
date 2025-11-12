defmodule EverybodyCodes.Day7 do
  @doc """
      iex> "priv/day7/example1.txt" |> EverybodyCodes.Day7.input() |> EverybodyCodes.Day7.part1()
      "Oroneth"
  """
  def part1({names, rules}) do
    names
    |> Enum.filter(fn name ->
      name
      |> String.to_charlist()
      |> walk(rules)
    end)
    |> List.first()
    |> to_string()
  end

  @doc """
      iex> "priv/day7/example2.txt" |> EverybodyCodes.Day7.input() |> EverybodyCodes.Day7.part2()
      23
  """
  def part2({names, rules}) do
    names
    |> Enum.with_index()
    |> Enum.filter(fn {name, _index} ->
      name
      |> String.to_charlist()
      |> walk(rules)
    end)
    |> Enum.map(fn {_name, index} -> index + 1 end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day7/example3.txt" |> EverybodyCodes.Day7.input() |> EverybodyCodes.Day7.part3()
      25

      iex> "priv/day7/example4.txt" |> EverybodyCodes.Day7.input() |> EverybodyCodes.Day7.part3()
      1154
  """
  def part3({names, rules}) do
    names
    |> Enum.flat_map(fn name ->
      nc = String.to_charlist(name)

      if walk(nc, rules) do
        count(nc, List.last(nc), length(nc), rules)
      else
        []
      end
    end)
    |> Enum.map(&to_string/1)
    |> Enum.uniq()
    |> length()
  end

  def count(nc, _let, len, _rules) when len == 11, do: [nc]

  def count(nc, let, len, rules) when len < 7 do
    Map.get(rules, let, [])
    |> Enum.flat_map(fn next ->
      count(nc ++ [next], next, len + 1, rules)
    end)
  end

  def count(nc, let, len, rules) do
    next_names =
      Map.get(rules, let, [])
      |> Enum.flat_map(fn next ->
        count(nc ++ [next], next, len + 1, rules)
      end)

    [nc | next_names]
  end

  def walk([], _rules), do: true

  def walk([h | t], rules) do
    cond do
      length(t) == 0 ->
        true

      Map.has_key?(rules, h) ->
        valid =
          rules
          |> Map.get(h)
          |> Enum.any?(fn next ->
            next == hd(t)
          end)

        if valid do
          walk(t, rules)
        else
          false
        end

      true ->
        false
    end
  end

  def input(filename) do
    [f, l] =
      filename
      |> File.read!()
      |> String.trim()
      |> String.split("\n\n", trim: true)

    m =
      l
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [s, e] =
          line
          |> String.split(" > ", trim: true)

        {String.to_charlist(s),
         String.split(e, ",", trim: true) |> Enum.map(&String.to_charlist/1)}
      end)
      |> Map.new()

    {String.split(f, ",", trim: true) |> Enum.map(&String.to_charlist/1), m}
  end
end
