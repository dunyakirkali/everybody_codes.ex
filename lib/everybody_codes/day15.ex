defmodule EverybodyCodes.Day15 do
  @doc """
      iex> "priv/day15/example1.txt" |> EverybodyCodes.Day15.input() |> EverybodyCodes.Day15.part1()
      6

      iex> "priv/day15/example2.txt" |> EverybodyCodes.Day15.input() |> EverybodyCodes.Day15.part1()
      16
  """
  def part1(instructions) do
    start = Complex.new(0)

    map = draw_map(%{start => "S"}, instructions)

    queue = :queue.in({start, 0}, :queue.new())
    # queue = Deque.new() |> Deque.append({start, 0})
    visited = MapSet.new([])
    size = size(map)
    walk(map, queue, visited, size)
  end

  def walk(map, queue, visited, {t, b, l, r} = size) do
    # {{pos, steps}, queue} = Deque.popleft(queue)
    {{:value, {pos, steps}}, queue} = :queue.out(queue)

    if Map.get(map, pos, ".") == "E" do
      steps
    else
      if MapSet.member?(visited, pos) do
        walk(map, queue, visited, size)
      else
        visited = MapSet.put(visited, pos)

        queue =
          neighbors(pos)
          |> Enum.filter(fn np ->
            b <= Complex.imag(np) and Complex.imag(np) <= t and
              l <= Complex.real(np) and Complex.real(np) <= r
          end)
          |> Enum.filter(fn np ->
            Map.get(map, np, ".") != "#"
          end)
          |> Enum.reduce(queue, fn npos, accd ->
            # Deque.append(accd, {npos, steps + 1})
            :queue.in({npos, steps + 1}, accd)
          end)

        walk(map, queue, visited, size)
      end
    end
  end

  def size(map) do
    t = map |> Map.keys() |> Enum.map(fn c -> Complex.imag(c) end) |> Enum.max() |> Kernel.+(1)
    b = map |> Map.keys() |> Enum.map(fn c -> Complex.imag(c) end) |> Enum.min() |> Kernel.-(1)
    r = map |> Map.keys() |> Enum.map(fn c -> Complex.real(c) end) |> Enum.max() |> Kernel.+(1)
    l = map |> Map.keys() |> Enum.map(fn c -> Complex.real(c) end) |> Enum.min() |> Kernel.-(1)
    {t, b, l, r}
  end

  def neighbors(point) do
    [
      Complex.add(point, Complex.new(1, 0)),
      Complex.add(point, Complex.new(-1, 0)),
      Complex.add(point, Complex.new(0, 1)),
      Complex.add(point, Complex.new(0, -1))
    ]
  end

  def draw_map(map, instructions) do
    {map, point, _direction} =
      instructions
      |> Enum.reduce({map, Complex.new(0), Complex.new(0, 1)}, fn {turn, size}, {mac, p, d} ->
        d =
          case turn do
            :right -> Complex.multiply(d, Complex.new(0, -1))
            :left -> Complex.multiply(d, Complex.new(0, 1))
          end

        {mac, p} =
          1..size
          |> Enum.reduce({mac, p}, fn _, {macc, pp} ->
            np = Complex.add(pp, d)
            macc = Map.put(macc, np, "#")
            {macc, np}
          end)

        {mac, p, d}
      end)

    Map.put(map, point, "E")
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn x ->
      [dir | rest] = String.graphemes(x)

      case dir do
        "R" -> {:right, String.to_integer(Enum.join(rest))}
        "L" -> {:left, String.to_integer(Enum.join(rest))}
      end
    end)
  end
end
