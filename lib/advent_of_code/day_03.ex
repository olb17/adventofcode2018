defmodule AdventOfCode.Day03 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_claim/1)
    |> Enum.reduce(%{}, fn claim, fabric ->
      for(
        x <- claim.x..(claim.x + claim.w - 1),
        y <- claim.y..(claim.y + claim.h - 1),
        do: {x, y}
      )
      |> Enum.reduce(fabric, fn point, fabric ->
        used_inch = Map.get(fabric, point, 0)
        Map.put(fabric, point, used_inch + 1)
      end)
    end)
    |> Enum.filter(fn {_point, value} -> value > 1 end)
    |> Enum.count()
  end

  def parse_claim(line) do
    [[_, id_str, x_str, y_str, w_str, h_str]] =
      Regex.scan(~r/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/, line)

    %{
      id: String.to_integer(id_str),
      x: String.to_integer(x_str),
      y: String.to_integer(y_str),
      w: String.to_integer(w_str),
      h: String.to_integer(h_str)
    }
  end

  def part2(_args) do
  end
end
