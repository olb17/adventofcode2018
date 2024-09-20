defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  @tag :skip2
  test "part1" do
    input = "dabAcCaCBAcCcaDA"
    result = part1(input)

    assert result == 10
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
