defmodule EverybodyCodes.Day1 do
  @doc """
      iex> "priv/day1/example1.txt" |> EverybodyCodes.Day1.input() |> EverybodyCodes.Day1.part1()
      "Fyrryn"
  """
  def part1([ns, ss]) do
    names = String.split(ns, ",", trim: true)
    length = length(names)

    ss
    |> String.split(",", trim: true)
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)
    |> Enum.reduce(0, fn [dir | step], acc ->
      step = Enum.join(step, "")

      case dir do
        "R" -> min(acc + String.to_integer(step), length - 1)
        "L" -> max(acc - String.to_integer(step), 0)
      end
    end)
    |> then(fn sum ->
      Enum.at(names, sum)
    end)
  end

  @doc """
      iex> "priv/day1/example2.txt" |> EverybodyCodes.Day1.input() |> EverybodyCodes.Day1.part2()
      "Elarzris"
  """
  def part2([ns, ss]) do
    names = String.split(ns, ",", trim: true)
    length = length(names)

    ss
    |> String.split(",", trim: true)
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)
    |> Enum.map(fn [dir | step] ->
      step = Enum.join(step, "")

      case dir do
        "R" -> String.to_integer(step)
        "L" -> -String.to_integer(step)
      end
    end)
    |> Enum.sum()
    |> then(fn sum ->
      Enum.at(names, rem(sum, length))
    end)
  end

  @doc """
      iex> "priv/day1/example3.txt" |> EverybodyCodes.Day1.input() |> EverybodyCodes.Day1.part3()
      "Drakzyph"
  """
  def part3([ns, ss]) do
    names = String.split(ns, ",", trim: true)
    length = length(names)

    ss
    |> String.split(",", trim: true)
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)
    |> Enum.reduce(names, fn [dir | step], acc ->
      step = Enum.join(step, "")

      case dir do
        "R" ->
          elem_i = Enum.at(acc, 0)
          elem_j = Enum.at(acc, String.to_integer(step))

          acc
          |> List.replace_at(0, elem_j)
          |> List.replace_at(String.to_integer(step), elem_i)

        "L" ->
          elem_i = Enum.at(acc, 0)
          elem_j = Enum.at(acc, length - String.to_integer(step))

          acc
          |> List.replace_at(0, elem_j)
          |> List.replace_at(length - String.to_integer(step), elem_i)
      end
    end)
    |> Enum.at(0)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n\n", trim: true)
  end
end
