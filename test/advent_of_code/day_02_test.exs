defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  @tag :skipa2
  test "part1" do
    input =
      """
      abcdef
          abcdef
            bababc
            abbcde
            abcccd
            aabcdd
            abcdee
            ababab
      """

    result = part1(input)

    assert result == 12
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
