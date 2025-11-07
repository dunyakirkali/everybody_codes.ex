defmodule Day5Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day5

  test "Part 1" do
    input = EverybodyCodes.Day5.input("priv/day5/input1.txt")
    assert EverybodyCodes.Day5.part1(input) == 8_346_565_745
  end

  test "Part 2" do
    input = EverybodyCodes.Day5.input_a("priv/day5/input2.txt")
    assert EverybodyCodes.Day5.part2(input) == 8_381_973_349_589
  end

  test "Part 3" do
    input = EverybodyCodes.Day5.input_a("priv/day5/input3.txt")
    assert EverybodyCodes.Day5.part3(input) == 32_181_125
  end
end
