defmodule EverybodyCodes.Day17 do
  use Memoize

  @doc """
      iex> "priv/day17/example1.txt" |> EverybodyCodes.Day17.input() |> EverybodyCodes.Day17.part1(1)
      21

      iex> "priv/day17/example1.txt" |> EverybodyCodes.Day17.input() |> EverybodyCodes.Day17.part1(2)
      68

      iex> "priv/day17/example1.txt" |> EverybodyCodes.Day17.input() |> EverybodyCodes.Day17.part1()
      1573
  """
  defmemo part1(map, radius \\ 10) do
    {center, _} = center(map)

    manhattan_inside(center, radius)
    |> Enum.reject(fn pos ->
      Map.get(map, pos) == "@"
    end)
    |> Enum.map(fn pos ->
      Map.get(map, pos, 0)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day17/example2.txt" |> EverybodyCodes.Day17.input() |> EverybodyCodes.Day17.part2(5)
      1090
  """
  def part2(map, max_radius \\ :infinity) do
    Stream.interval(1)
    |> Enum.reduce_while([], fn radius, acc ->
      destruction =
        for(i <- 1..(radius + 1), do: part1(map, i))
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)
        |> List.last()

      cond do
        radius == max_radius -> {:halt, Enum.reverse(acc)}
        destruction == 0 -> {:halt, Enum.reverse(acc)}
        destruction == nil -> {:cont, [{part1(map, 1), radius + 1} | acc]}
        true -> {:cont, [{destruction, radius + 1} | acc]}
      end
    end)
    |> Enum.max_by(fn {destruction, _radius} -> destruction end)
    |> then(fn {destruction, radius} -> destruction * radius end)
  end

  @doc """
      iex> "priv/day17/example3.txt" |> EverybodyCodes.Day17.input() |> EverybodyCodes.Day17.part3()
      592

      #iex> "priv/day17/example4.txt" |> EverybodyCodes.Day17.input() |> EverybodyCodes.Day17.part3()
      #330

      #iex> "priv/day17/example5.txt" |> EverybodyCodes.Day17.input() |> EverybodyCodes.Day17.part3()
      #3180
  """
  def part3(map) do
    map = mirror(map)

    {_w, h} = size(map)

    start =
      map
      |> Enum.find(fn {_pos, v} -> v == "S" end)
      |> elem(0)

    dest =
      map
      |> Enum.find(fn {_pos, v} -> v == "E" end)
      |> elem(0)

    centers = map |> Enum.filter(fn {_pos, v} -> v == "@" end) |> Enum.map(fn {pos, _} -> pos end)
    queue = PriorityQueue.new() |> PriorityQueue.push({start, 0, [], 0}, 0)
    visited = MapSet.new([])

    {radius, path, cost} = walk(map, queue, visited, dest, centers, h + 1)
    {radius, cost} |> IO.inspect()
    IO.inspect(path |> Enum.map(fn {x, y} -> {y + 1, x + 1} end))
    cost * radius
  end

  def walk(map, deque, visited, dest, centers, h) do
    {{:value, {pos, radius, path, time}}, deque} =
      PriorityQueue.pop(deque)

    if pos == dest do
      {radius, path, time}
    else
      if MapSet.member?(visited, {pos, time}) do
        walk(map, deque, visited, dest, centers, h)
      else
        visited = MapSet.put(visited, {pos, time})
        rad = div(time, 30)
        [c1, c2] = centers

        lava =
          manhattan_inside(c1, rad)
          |> MapSet.new()
          |> MapSet.union(MapSet.new(manhattan_inside(c2, rad)))

        intersection =
          lava
          |> MapSet.intersection(MapSet.new(path))
          |> MapSet.size()

        if intersection > 0 do
          walk(map, deque, visited, dest, centers, h)
        else
          deque =
            pos
            |> options(h)
            |> Enum.filter(fn np ->
              not Enum.member?([".", "@"], Map.get(map, np, "."))
            end)
            |> Enum.reduce(deque, fn np, deque ->
              dur =
                case Map.get(map, np) do
                  "E" -> 0
                  "S" -> 0
                  v -> v
                end

              PriorityQueue.push(
                deque,
                {
                  np,
                  rad,
                  [np | path],
                  time + dur
                },
                time + dur
              )
            end)

          walk(map, deque, visited, dest, centers, h)
        end
      end
    end
  end

  def options({x, y}, height) do
    quart = div(height, 4)

    if y > quart do
      [
        {x + 1, y},
        {x - 1, y},
        {x, y + 1},
        {x + 1, height - y - 1},
        {x - 1, height - y - 1},
        {x, height - y},
        {x, height - y - 2}
      ]
    else
      [
        {x + 1, y},
        {x - 1, y},
        {x, y + 1},
        {x, y - 1}
      ]
    end
  end

  def mirror(grid) do
    # bounds
    ys = Enum.map(Map.keys(grid), fn {_, y} -> y end)
    min_y = Enum.min(ys)
    max_y = Enum.max(ys)

    # find pivot "@"
    {pivot_x, pivot_y} =
      grid
      |> Enum.find(fn {_pos, v} -> v == "@" end)
      |> elem(0)

    # --- Step 1: Remove top-right quadrant in original only ---
    cleaned_original =
      grid
      |> Enum.map(fn
        {{x, y}, _val} when y < pivot_y and x > pivot_x -> {{x, y}, "."}
        other -> other
      end)
      |> Map.new()

    # --- Step 2: Mirror vertically excluding last row ---
    rows_to_mirror =
      min_y..(max_y - 1)
      |> Enum.to_list()
      |> Enum.reverse()

    mirrored =
      Enum.reduce(rows_to_mirror, %{}, fn y, acc ->
        new_y = max_y + (max_y - y)

        # take the original row (not cleaned)
        row_cells =
          grid
          |> Enum.filter(fn {{_x, row_y}, _val} -> row_y == y end)
          |> Enum.map(fn {{x, _}, val} ->
            # bottom-left removal in mirrored section
            new_val =
              cond do
                x < pivot_x -> "."
                val == "S" -> "E"
                true -> val
              end

            {{x, new_y}, new_val}
          end)

        Map.merge(acc, Map.new(row_cells))
      end)

    Map.merge(cleaned_original, mirrored)
  end

  def render(grid) do
    xs = Enum.map(Map.keys(grid), fn {x, _} -> x end)
    ys = Enum.map(Map.keys(grid), fn {_, y} -> y end)
    min_x = Enum.min(xs)
    max_x = Enum.max(xs)
    min_y = Enum.min(ys)
    max_y = Enum.max(ys)

    for y <- min_y..max_y do
      for x <- min_x..max_x do
        Map.get(grid, {x, y}, " ")
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end

  def size(map) do
    xs = map |> Map.keys() |> Enum.map(fn {x, _y} -> x end)
    ys = map |> Map.keys() |> Enum.map(fn {_x, y} -> y end)
    {Enum.max(xs), Enum.max(ys)}
  end

  def manhattan_inside({xc, yc}, r) do
    for x <- (xc - r)..(xc + r),
        y <- (yc - r)..(yc + r),
        (x - xc) * (x - xc) + (y - yc) * (y - yc) <= r * r do
      {x, y}
    end
  end

  def center(map) do
    Enum.find(map, fn {_pos, val} -> val == "@" end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, acc ->
        case cell do
          "@" -> Map.put(acc, {x, y}, cell)
          "S" -> Map.put(acc, {x, y}, cell)
          _ -> Map.put(acc, {x, y}, String.to_integer(cell))
        end
      end)
    end)
  end
end
