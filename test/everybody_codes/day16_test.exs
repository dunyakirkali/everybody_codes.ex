defmodule Day16Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day16

  test "Part 1" do
    input = EverybodyCodes.Day16.input("priv/day16/input1.txt")
    assert EverybodyCodes.Day16.part1(input) == 263
  end

  test "Part 2" do
    input = EverybodyCodes.Day16.input("priv/day16/input2.txt")
    assert EverybodyCodes.Day16.part2(input) == 187_081_526_016
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day16.input("priv/day16/input3.txt")
    assert EverybodyCodes.Day16.part3(input, 202_520_252_025_000) == 94_450_193_710_489
  end
end
