defmodule Day6Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day6

  test "Part 1" do
    input = EverybodyCodes.Day6.input("priv/day6/input1.txt")
    assert EverybodyCodes.Day6.part1(input) == 133
  end

  test "Part 2" do
    input = EverybodyCodes.Day6.input("priv/day6/input2.txt")
    assert EverybodyCodes.Day6.part2(input) == 3840
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day6.input("priv/day6/input3.txt")
    assert EverybodyCodes.Day6.part3(input, 1000, 1000) == 1_665_808_254
  end
end
