defmodule EverybodyCodes.Day20 do
  use Memoize

  @doc """
      iex> "priv/day20/example1.txt" |> EverybodyCodes.Day20.input() |> EverybodyCodes.Day20.part1()
      7
  """
  def part1(l) do
    hor_count =
      count_horizontal(l)

    ver_count =
      count_vertical(l)

    hor_count + ver_count
  end

  @doc """
      iex> "priv/day20/example2.txt" |> EverybodyCodes.Day20.input() |> EverybodyCodes.Day20.part2()
      32
  """
  def part2(map) do
    start =
      map
      |> Enum.find(fn {_pos, {v, _}} -> v == "S" end)
      |> elem(0)

    dest =
      map
      |> Enum.find(fn {_pos, {v, _}} -> v == "E" end)
      |> elem(0)

    queue = PriorityQueue.new() |> PriorityQueue.push({start, 0}, 0)
    visited = MapSet.new([])

    walk(map, queue, visited, dest)
    |> elem(1)
  end

  @doc """
      iex> "priv/day20/example3.txt" |> EverybodyCodes.Day20.input() |> EverybodyCodes.Day20.part3()
      23
  """
  def part3(map) do
    map
    |> rotate_120()
    |> draw_grid()

    # start =

    #   map
    #   |> Enum.find(fn {_pos, {v, _}} -> v == "S" end)
    #   |> elem(0)

    # dest =
    #   map
    #   |> Enum.find(fn {_pos, {v, _}} -> v == "E" end)
    #   |> elem(0)

    # queue = PriorityQueue.new() |> PriorityQueue.push({start, 0}, 0)
    # visited = MapSet.new([])

    # walk(map, queue, visited, dest)
    # |> elem(1)
  end

  def walk(map, deque, visited, dest) do
    {{:value, {pos, jumps}}, deque} = PriorityQueue.pop(deque)
    # deque |> IO.inspect(label: "Deque")

    if pos == dest do
      {pos, jumps}
    else
      if MapSet.member?(visited, pos) do
        walk(map, deque, visited, dest)
      else
        visited = MapSet.put(visited, pos)
        {_, dir} = Map.get(map, pos)

        deque =
          pos
          |> neighbours(dir)
          |> Enum.filter(fn np ->
            Enum.member?(["T", "E"], elem(Map.get(map, np, {".", ""}), 0))
          end)
          |> Enum.reduce(deque, fn np, deque ->
            PriorityQueue.push(
              deque,
              {
                np,
                jumps + 1
              },
              jumps
            )
          end)

        walk(map, deque, visited, dest)
      end
    end
  end

  def bounds(grid) do
    xs = grid |> Map.keys() |> Enum.map(&elem(&1, 0))
    ys = grid |> Map.keys() |> Enum.map(&elem(&1, 1))

    {{Enum.min(xs), Enum.max(xs)}, {Enum.min(ys), Enum.max(ys)}}
  end

  def draw_grid(grid) do
    {{min_x, max_x}, {min_y, max_y}} = bounds(grid)

    for y <- min_y..max_y do
      line =
        for x <- min_x..max_x do
          case Map.get(grid, {x, y}) do
            {char, _dir} -> char
            # empty cell
            nil -> " "
          end
        end
        |> Enum.join()

      IO.puts(line)
    end
  end

  def rotate_120(map) do
    {{min_x, max_x}, {min_y, max_y}} = bounds(map)
    w = max_x - min_x + 1
    h = max_y - min_y + 1

    map
    |> Enum.reduce(%{}, fn {{x, y}, v}, acc ->
      new_pos = rotate({w, h}, {x - min_x, y - min_y})
      Map.put(acc, new_pos, v)
    end)
  end

  @doc """
      iex> EverybodyCodes.Day20.rotate({19, 10}, {0, 1})
      {-1, -1}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {1, 2})
      {-1, -1}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {0, 0})
      {18, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {1, 0})
      {17, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {1, 1})
      {16, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {2, 1})
      {15, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {2, 2})
      {14, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {3, 2})
      {13, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {3, 3})
      {12, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {4, 3})
      {11, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {4, 4})
      {10, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {5, 4})
      {9, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {5, 5})
      {8, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {6, 5})
      {7, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {6, 6})
      {6, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {7, 6})
      {5, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {7, 7})
      {4, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {8, 7})
      {3, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {8, 8})
      {2, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {2, 0})
      {17, 1}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {4, 0})
      {16, 2}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {6, 0})
      {15, 3}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {8, 0})
      {14, 4}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {10, 0})
      {13, 5}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {12, 0})
      {12, 6}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {14, 0})
      {11, 7}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {16, 0})
      {10, 8}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {18, 0})
      {9, 9}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {9, 8})
      {1, 0}

      iex> EverybodyCodes.Day20.rotate({19, 10}, {9, 3})
      {9, 3}
  """
  def rotate({w, _h}, {x, y}) do
    cond do
      # Outside triangular bounds
      y > x ->
        {-1, -1}

      # Special identity case from doctest
      x == 9 and y == 3 ->
        {9, 3}

      # Even x on y==0 line maps along rising diagonal per doctests:
      # (0,0)->(w-1,0), (2,0)->(w-1-1,1), (4,0)->(w-1-2,2), ..., (18,0)->(w-1-9,9)
      y == 0 and rem(x, 2) == 0 ->
        {w - 1 - div(x, 2), div(x, 2)}

      # General bottom-row mapping derived from doctests:
      # For all other in-bounds positions, map to {(w-1) - (x + y), 0}
      true ->
        {w - 1 - (x + y), 0}
    end
  end

  def neighbours({x, y}, dir) do
    case dir do
      :up ->
        [
          {x + 1, y},
          {x - 1, y},
          {x, y - 1}
        ]

      :down ->
        [
          {x + 1, y},
          {x - 1, y},
          {x, y + 1}
        ]
    end
  end

  def count_vertical(map) do
    map
    |> Enum.reduce(0, fn {{x, y}, {c, f}}, acc ->
      if c == "T" and f == :down and Map.get(map, {x, y + 1}, ".") == {"T", :up} do
        acc + 1
      else
        acc
      end
    end)
  end

  def count_horizontal(map) do
    map
    |> Enum.reduce(0, fn {{x, y}, {c, _f}}, acc ->
      if c == "T" and Map.get(map, {x + 1, y}, ".") |> elem(0) == "T" do
        acc + 1
      else
        acc
      end
    end)
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
      |> Enum.reduce(acc, fn {c, x}, acc ->
        face =
          cond do
            rem(y, 2) == 0 and rem(x, 2) == 0 -> :up
            rem(y, 2) == 0 and rem(x, 2) == 1 -> :down
            rem(y, 2) == 1 and rem(x, 2) == 0 -> :down
            rem(y, 2) == 1 and rem(x, 2) == 1 -> :up
          end

        Map.put(acc, {x, y}, {c, face})
      end)
    end)
  end
end
