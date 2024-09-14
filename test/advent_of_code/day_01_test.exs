defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @tag :skip
  test "part1" do
    input = nil
    result = part1(input)

    assert result
  end

  @tag :skip2
  test "part2" do
    input = """
    +3
    +3
    +4
    -2
    -4
    """

    result = part2(input)

    assert result == 10
  end
end
