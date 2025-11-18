defmodule Day11Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day11

  test "Part 1" do
    input = EverybodyCodes.Day11.input("priv/day11/input1.txt")
    assert EverybodyCodes.Day11.part1(input) == 291
  end

  test "Part 2" do
    input = EverybodyCodes.Day11.input("priv/day11/input2.txt")
    assert EverybodyCodes.Day11.part2(input) == 2_631_585
  end

  @tag timeout: :infinity
  test "Part 3" do
    input = EverybodyCodes.Day11.input("priv/day11/input3.txt")
    assert EverybodyCodes.Day11.part3(input) == 142_555_212_296_239
  end
end
