defmodule Day10Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day10

  test "Part 1" do
    input = EverybodyCodes.Day10.input("priv/day10/input1.txt")
    assert EverybodyCodes.Day10.part1(input, 4) == 158
  end

  test "Part 2" do
    input = EverybodyCodes.Day10.input("priv/day10/input2.txt")
    assert EverybodyCodes.Day10.part2(input, 20) == 1672
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day10.input("priv/day10/input3.txt")
    assert EverybodyCodes.Day10.part3(input) == 73_415_313_972_879
  end
end
