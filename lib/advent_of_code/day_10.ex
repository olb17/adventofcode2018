defmodule AdventOfCode.Day10 do
  @regex ~r/position=<\s*(-?\d+),\s+(-?\d+)> velocity=<\s*(-?\d+),\s+(-?\d+)>/

  def part1(args) do
    points =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_, ys, xs, dys, dxs] =
          Regex.run(@regex, line)

        %{
          x: String.to_integer(xs),
          y: String.to_integer(ys),
          dx: String.to_integer(dxs),
          dy: String.to_integer(dys)
        }
      end)

    for n <- 1..30000 do
      points
      |> move(n)
      |> display()
    end

    :ok
  end

  def move(points, n) do
    points
    |> Enum.map(fn %{x: x, y: y, dx: dx, dy: dy} ->
      %{x: x + n * dx, y: y + dy * n, dx: dx, dy: dy}
    end)
  end

  def display(points) do
    min_x = points |> Enum.min_by(& &1.x) |> Map.get(:x)
    min_y = points |> Enum.min_by(& &1.y) |> Map.get(:y)
    max_x = points |> Enum.max_by(& &1.x) |> Map.get(:x)
    max_y = points |> Enum.max_by(& &1.y) |> Map.get(:y)

    if max_x - min_x <= 10 do
      IO.puts("")

      for x <- min_x..max_x do
        for y <- min_y..max_y do
          if x == 0 and y == 0 do
            "0"
          else
            case Enum.find(points, &(&1.x == x and &1.y == y)) do
              nil -> "."
              _ -> "#"
            end
          end
          |> IO.write()
        end

        IO.puts("")
      end
    end
  end

  def part2(_args) do
  end
end
