defmodule Day18Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day18

  test "Part 1" do
    input = EverybodyCodes.Day18.input("priv/day18/input1.txt")
    assert EverybodyCodes.Day18.part1(input) == 1_493_844
  end

  test "Part 2" do
    input = EverybodyCodes.Day18.input2("priv/day18/input2.txt")
    assert EverybodyCodes.Day18.part2(input) == 11_409_534_101
  end

  # @tag timeout: :infinity
  # test "Part 3" do
  #   input = EverybodyCodes.Day18.input("priv/day18/input3.txt")
  #   assert EverybodyCodes.Day18.part3(input, 202_520_252_025_000) == 94_450_193_710_489
  # end
end
