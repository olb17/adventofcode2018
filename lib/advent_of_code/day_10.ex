defmodule AdventOfCode.Day10 do
  @regex ~r/position=<\s*(-?\d+),\s+(-?\d+)> velocity=<\s*(-?\d+),\s+(-?\d+)>/

  def part1(args) do
    points =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_, ys, xs, dys, dxs] = Regex.run(@regex, line)

        %{
          x: String.to_integer(xs),
          y: String.to_integer(ys),
          dx: String.to_integer(dxs),
          dy: String.to_integer(dys)
        }
      end)

    display(points, 0)
  end

  def display(points, n) do
    night =
      points
      |> Enum.map(fn %{x: x, y: y, dx: dx, dy: dy} ->
        %{x: x + n * dx, y: y + dy * n, dx: dx, dy: dy}
      end)

    min_x = night |> Enum.min_by(& &1.x) |> Map.get(:x)
    min_y = night |> Enum.min_by(& &1.y) |> Map.get(:y)
    max_x = night |> Enum.max_by(& &1.x) |> Map.get(:x)
    max_y = night |> Enum.max_by(& &1.y) |> Map.get(:y)

    # Characters stands on 1 line (height of 10 points)
    if max_x - min_x <= 10 do
      for x <- min_x..max_x do
        for y <- min_y..max_y do
          case Enum.find(night, &(&1.x == x and &1.y == y)) do
            nil -> "."
            _ -> "#"
          end
          |> IO.write()
        end

        IO.puts("")
      end

      IO.puts("Number of seconds: #{n}")
    else
      display(points, n + 1)
    end
  end

  def part2(args) do
    part1(args)
  end
end
