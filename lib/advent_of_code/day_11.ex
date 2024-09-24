defmodule AdventOfCode.Day11 do
  @grid_serial_number 8868

  def part1(_args) do
    power_grid =
      for x <- 1..300, y <- 1..300 do
        {{x, y}, power_level({x, y})}
      end
      |> Map.new()

    for i <- 1..(300 - 3), j <- 1..(300 - 3) do
      {i, j}
    end
    |> Enum.max_by(&square_power(&1, power_grid))
  end

  defp square_power({x, y}, power_grid) do
    [{0, 0}, {1, 0}, {2, 0}, {0, 1}, {1, 1}, {2, 1}, {0, 2}, {1, 2}, {2, 2}]
    |> Enum.map(fn {dx, dy} -> Map.get(power_grid, {x + dx, y + dy}) end)
    |> Enum.sum()
  end

  defp power_level({x, y}) do
    rack_id = x + 10
    power_level = rack_id * y
    power_level = power_level + @grid_serial_number
    power_level = power_level * rack_id
    power_level = div(power_level, 100) |> rem(10)
    power_level - 5
  end

  def part2(_args) do
  end
end
