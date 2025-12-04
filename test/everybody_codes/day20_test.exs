defmodule Day20Test do
  use ExUnit.Case
  doctest EverybodyCodes.Day20

  test "Part 1" do
    input = EverybodyCodes.Day20.input("priv/day20/input1.txt")
    assert EverybodyCodes.Day20.part1(input) == 120
  end

  test "Part 2" do
    input = EverybodyCodes.Day20.input("priv/day20/input2.txt")
    assert EverybodyCodes.Day20.part2(input) == 569
  end

  # @tag timeout: :infinity
  # test "Part 3" do
  #   input = EverybodyCodes.Day20.input("priv/day20/input3.txt")
  #   assert EverybodyCodes.Day20.part2(input) == 4_398_843
  # end
end
