defmodule Day12Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day12

  test "Part 1" do
    input = EverybodyCodes.Day12.input("priv/day12/input1.txt")
    assert EverybodyCodes.Day12.part1(input) == 249
  end

  test "Part 2" do
    input = EverybodyCodes.Day12.input("priv/day12/input2.txt")
    assert EverybodyCodes.Day12.part2(input) == 5744
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day12.input("priv/day12/input3.txt")
    assert EverybodyCodes.Day12.part3(input) == 3965
  end
end
