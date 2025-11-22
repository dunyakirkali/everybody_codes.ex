defmodule Day15Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day15

  test "Part 1" do
    input = EverybodyCodes.Day15.input("priv/day15/input1.txt")
    assert EverybodyCodes.Day15.part1(input) == 107
  end

  test "Part 2" do
    input = EverybodyCodes.Day15.input("priv/day15/input2.txt")
    assert EverybodyCodes.Day15.part1(input) == 3836
  end

  # @tag timeout: :infinity
  # test "Part 3" do
  #   input = EverybodyCodes.Day15.input("priv/day15/input3.txt")
  #   assert EverybodyCodes.Day15.part1(input) == 1_052_015_428
  # end
end
