defmodule EverybodyCodesTest do
  use ExUnit.Case
  doctest EverybodyCodes

  test "greets the world" do
    assert EverybodyCodes.hello() == :world
  end
end
