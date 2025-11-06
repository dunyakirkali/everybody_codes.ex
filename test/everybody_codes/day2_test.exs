defmodule Day2Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day2

  # test "Part 1" do
  #   input = EverybodyCodes.Day1.input("priv/day1/input.txt")
  #   assert EverybodyCodes.Day1.part1(input) == 1_834_060
  # end

  test "Part 2" do
    input = EverybodyCodes.Day2.input("priv/day2/input2.txt")
    assert EverybodyCodes.Day2.part2(input) == 642
  end

  test "Part 3" do
    input = EverybodyCodes.Day2.input("priv/day2/input3.txt")
    assert EverybodyCodes.Day2.part3(input) == 642
  end
end
