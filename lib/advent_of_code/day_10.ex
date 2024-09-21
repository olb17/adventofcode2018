defmodule AdventOfCode.Day10 do
  @regex ~r/position=<\s*(-?\d+),\s+(-?\d+)> velocity=<\s*(-?\d+),\s+(-?\d+)>/

  def part1(args) do
    points =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [y, x, dy, dx] =
          Regex.run(@regex, line, capture: :all_but_first)
          |> Enum.map(&String.to_integer/1)

        %{x: x, y: y, dx: dx, dy: dy}
      end)

    search(points, 0)
  end

  def search(points, n) do
    night =
      points
      |> Enum.map(fn %{x: x, y: y, dx: dx, dy: dy} ->
        {x + n * dx, y + dy * n}
      end)
      |> MapSet.new()

    {min_x, max_x} = night |> Enum.map(&elem(&1, 0)) |> Enum.min_max()

    # Characters stands on 1 line (height of 10 points)
    if max_x - min_x <= 10 do
      display(night, min_x, max_x, n)
    else
      search(points, n + 1)
    end
  end

  def display(night, min_x, max_x, n) do
    {min_y, max_y} = night |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    for x <- min_x..max_x do
      for y <- min_y..max_y do
        if(MapSet.member?(night, {x, y}),
          do: "#",
          else: " "
        )
        |> IO.write()
      end

      IO.puts("")
    end

    IO.puts("Number of seconds: #{n}")
  end

  def part2(args) do
    part1(args)
  end
end
