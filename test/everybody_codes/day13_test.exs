defmodule Day13Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day13

  test "Part 1" do
    input = EverybodyCodes.Day13.input("priv/day13/input1.txt")
    assert EverybodyCodes.Day13.part1(input) == 987
  end

  test "Part 2" do
    input = EverybodyCodes.Day13.input2("priv/day13/input2.txt")
    assert EverybodyCodes.Day13.part2(input) == 2289
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day13.input3("priv/day13/input3.txt")
    assert EverybodyCodes.Day13.part3(input) == 521_368
  end
end
