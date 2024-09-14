defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "+" <> n -> String.to_integer(n)
      "-" <> n -> -String.to_integer(n)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "+" <> n -> String.to_integer(n)
      "-" <> n -> -String.to_integer(n)
    end)
    |> Stream.cycle()
    |> Enum.reduce_while({0, []}, fn change, {freq, known_freq} ->
      new_freq = freq + change

      if Enum.member?(known_freq, new_freq) do
        {:halt, new_freq}
      else
        {:cont, {new_freq, [new_freq | known_freq]}}
      end
    end)
  end
end
