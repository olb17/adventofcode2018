defmodule AdventOfCode.Day05 do
  def part1(args) do
    args
    |> String.trim()
    |> String.to_charlist()
    |> then(&react([], &1))
    |> length()
  end

  @dist ?a - ?A
  def react(polymer, []), do: polymer
  def react([], [p_h | i_rest]), do: react([p_h], i_rest)

  def react([p_h | p_rest], [i_h | i_rest]) when abs(p_h - i_h) == @dist,
    do: react(p_rest, i_rest)

  def react([p_h | p_rest], [i_h | i_rest]), do: react([i_h | [p_h | p_rest]], i_rest)

  def part2(_args) do
  end
end
