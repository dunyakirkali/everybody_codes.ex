defmodule Day7Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day7

  test "Part 1" do
    input = EverybodyCodes.Day7.input("priv/day7/input1.txt")
    assert EverybodyCodes.Day7.part1(input) == "Azmirath"
  end

  test "Part 2" do
    input = EverybodyCodes.Day7.input("priv/day7/input2.txt")
    assert EverybodyCodes.Day7.part2(input) == 2352
  end

  test "Part 3" do
    input = EverybodyCodes.Day7.input("priv/day7/input3.txt")
    assert EverybodyCodes.Day7.part3(input) == 2_325_663
  end
end
