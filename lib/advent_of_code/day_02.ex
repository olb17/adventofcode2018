defmodule AdventOfCode.Day02 do
  def part1(args) do
    freq =
      args
      |> String.split("\n", trim: true)
      |> Enum.flat_map(fn line ->
        freq = line |> String.split("", trim: true) |> Enum.frequencies()
        n_2 = freq |> Enum.filter(fn {_letter, freq} -> freq == 2 end) |> Enum.count()
        n_3 = freq |> Enum.filter(fn {_letter, freq} -> freq == 3 end) |> Enum.count()
        [{2, n_2}, {3, n_3}]
      end)
      |> dbg

    n_2 = Enum.filter(freq, fn {f, n} -> f == 2 && n > 0 end) |> Enum.count()
    n_3 = Enum.filter(freq, fn {f, n} -> f == 3 && n > 0 end) |> Enum.count()

    n_2 * n_3
  end

  def part2(_args) do
  end
end
