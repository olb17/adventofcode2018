defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  @input ~s"""
  /->-\\        
  |   |  /----\\
  | /-+--+-\\  |
  | | |  | v  |
  \\-+-/  \\-+--/
    \\------/
  """

  @input2 ~s"""
  />-<\\  
  |   |  
  | /<+-\\
  | | | v
  \\>+</ |
    |   ^
    \\<->/
  """

  @tag :skip
  test "part1" do
    input = @input
    result = part1(input)

    assert result == "7,3"
  end

  @tag :skip
  test "part2" do
    input = @input2
    result = part2(input)

    assert result == "6,4"
  end
end
