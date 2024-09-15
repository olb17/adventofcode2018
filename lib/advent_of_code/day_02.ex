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

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> find_max("")
  end

  def find_max([_], max) do
    max
  end

  def find_max([head | tail], max) do
    local_max =
      Enum.map(tail, &compare_string(head, &1))
      |> Enum.max_by(&String.length/1)

    if String.length(max) > String.length(local_max) do
      find_max(tail, max)
    else
      find_max(tail, local_max)
    end
  end

  def compare_string(str1, str2) do
    [String.split(str1, "", trim: true), String.split(str2, "", trim: true)]
    |> Enum.zip()
    |> Enum.flat_map(fn
      {c, c} -> [c]
      {_, _} -> []
    end)
    |> Enum.join("")
  end
end
