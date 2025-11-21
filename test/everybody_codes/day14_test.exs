defmodule Day14Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day14

  test "Part 1" do
    input = EverybodyCodes.Day14.input("priv/day14/input1.txt")
    assert EverybodyCodes.Day14.part1(input) == 509
  end

  test "Part 2" do
    input = EverybodyCodes.Day14.input("priv/day14/input2.txt")
    assert EverybodyCodes.Day14.part2(input) == 1_170_588
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day14.input("priv/day14/input3.txt")
    assert EverybodyCodes.Day14.part3(input) == 1_052_015_428
  end
end
