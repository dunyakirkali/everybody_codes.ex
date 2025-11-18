defmodule Day9Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day9

  test "Part 1" do
    input = EverybodyCodes.Day9.input("priv/day9/input1.txt")
    assert EverybodyCodes.Day9.part1(input) == 6715
  end

  test "Part 2" do
    input = EverybodyCodes.Day9.input("priv/day9/input2.txt")
    assert EverybodyCodes.Day9.part2(input) == 315_771
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day9.input("priv/day9/input3.txt")
    assert EverybodyCodes.Day9.part3(input) == 711
  end
end
