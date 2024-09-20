defmodule AdventOfCode.Day05 do
  def part1(args) do
    args
    |> String.trim()
    |> String.to_charlist()
    |> then(&react([], &1))
  end

  @dist ?a - ?A
  def react(polymer, []), do: length(polymer)
  def react([], [p_h | i_rest]), do: react([p_h], i_rest)

  def react([p_h | p_rest], [i_h | i_rest]) when abs(p_h - i_h) == @dist,
    do: react(p_rest, i_rest)

  def react([p_h | p_rest], [i_h | i_rest]), do: react([i_h | [p_h | p_rest]], i_rest)

  def part2(args) do
    ?a..?z
    |> Enum.map(&remove_pair(args, &1))
    |> Enum.min()
  end

  def remove_pair(args, char) do
    args
    |> String.trim()
    |> String.to_charlist()
    |> Enum.reject(&(&1 == char or &1 == char - @dist))
    |> then(&react([], &1))
  end
end
