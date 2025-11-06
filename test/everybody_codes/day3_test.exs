defmodule Day3Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day3

  test "Part 1" do
    input = EverybodyCodes.Day3.input("priv/day3/input1.txt")
    assert EverybodyCodes.Day3.part1(input) == 3039
  end

  test "Part 2" do
    input = EverybodyCodes.Day3.input("priv/day3/input2.txt")
    assert EverybodyCodes.Day3.part2(input) == 266
  end

  test "Part 3" do
    input = EverybodyCodes.Day3.input("priv/day3/input3.txt")
    assert EverybodyCodes.Day3.part3(input) == 2939
  end
end
