defmodule Day8Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day8

  test "Part 1" do
    input = EverybodyCodes.Day8.input("priv/day8/input1.txt")
    assert EverybodyCodes.Day8.part1(input) == 60
  end

  test "Part 2" do
    input = EverybodyCodes.Day8.input("priv/day8/input2.txt")
    assert EverybodyCodes.Day8.part2(input) == 2_924_476
  end

  test "Part 3" do
    input = EverybodyCodes.Day8.input("priv/day8/input3.txt")
    assert EverybodyCodes.Day8.part3(input) == 2799
  end
end
