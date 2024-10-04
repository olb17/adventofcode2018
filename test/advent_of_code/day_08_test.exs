defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Day08

  @input """
  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
  """
  @tag :skip
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 138
  end

  @tag :skip
  test "part2" do
    input = @input
    result = part2(input)

    assert result == 66
  end
end
