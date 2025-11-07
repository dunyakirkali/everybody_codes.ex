defmodule Day4Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day4

  test "Part 1" do
    input = EverybodyCodes.Day4.input("priv/day4/input1.txt")
    assert EverybodyCodes.Day4.part1(input) == 11505
  end

  test "Part 2" do
    input = EverybodyCodes.Day4.input("priv/day4/input2.txt")
    assert EverybodyCodes.Day4.part2(input) == 1_766_630_316_249
  end

  test "Part 3" do
    input = EverybodyCodes.Day4.input_a("priv/day4/input3.txt")
    assert EverybodyCodes.Day4.part3(input) == 266_269_070_529
  end
end
