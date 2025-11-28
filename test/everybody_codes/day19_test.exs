defmodule Day19Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day19

  test "Part 1" do
    input = EverybodyCodes.Day19.input("priv/day19/input1.txt")
    assert EverybodyCodes.Day19.part1(input) == 52
  end

  test "Part 2" do
    input = EverybodyCodes.Day19.input("priv/day19/input2.txt")
    assert EverybodyCodes.Day19.part2(input) == 680
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day19.input("priv/day19/input3.txt")
    assert EverybodyCodes.Day19.part2(input) == 4_398_843
  end
end
