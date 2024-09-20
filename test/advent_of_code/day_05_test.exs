defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  @input "dabAcCaCBAcCcaDA"

  @tag :skip
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 10
  end

  @tag :skip
  test "part2" do
    input = @input
    result = part2(input)

    assert result == 4
  end
end
