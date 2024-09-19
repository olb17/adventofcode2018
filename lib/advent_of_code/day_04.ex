defmodule AdventOfCode.Day04 do
  @regex ~r/\[(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2})\] (Guard #(\d+) begins shift|.*)/

  def part1(args) do
    {_, guards_day_min_asleep} =
      args
      |> String.split("\n", trim: true)
      |> Enum.flat_map(&parse_line/1)
      |> Enum.sort_by(fn {date, _} -> date end, {:asc, NaiveDateTime})
      |> Enum.reduce(
        {nil, %{}},
        fn
          {datetime, {:guard, guard_id}}, {_, guards_day_min_asleep} ->
            ogma =
              if datetime.hour == 0 do
                today = NaiveDateTime.to_date(datetime)

                datetime.minute..59
                |> Enum.reduce(guards_day_min_asleep, fn min, acc ->
                  put_in(acc, Enum.map([guard_id, today, min], &Access.key(&1, %{})), 0)
                end)
              else
                today =
                  datetime
                  |> NaiveDateTime.beginning_of_day()
                  |> NaiveDateTime.to_date()
                  |> Date.add(1)

                0..59
                |> Enum.reduce(guards_day_min_asleep, fn min, acc ->
                  put_in(acc, Enum.map([guard_id, today, min], &Access.key(&1, %{})), 0)
                end)
              end

            {guard_id, ogma}

          {datetime, :sleep}, {cur_guard, guards_min_asleep} ->
            ogma =
              if datetime.hour == 0 do
                today = NaiveDateTime.to_date(datetime)

                datetime.minute..59
                |> Enum.reduce(guards_min_asleep, fn min, acc ->
                  put_in(acc, Enum.map([cur_guard, today, min], &Access.key(&1, %{})), 1)
                end)
              else
                today =
                  datetime
                  |> NaiveDateTime.beginning_of_day()
                  |> NaiveDateTime.to_date()
                  |> Date.add(1)

                0..59
                |> Enum.reduce(guards_min_asleep, fn min, acc ->
                  put_in(acc, Enum.map([cur_guard, today, min], &Access.key(&1, %{})), 1)
                end)
              end

            {cur_guard, ogma}

          {datetime, :wakes_up}, {cur_guard, guards_min_asleep} ->
            ogma =
              if datetime.hour == 0 do
                today = NaiveDateTime.to_date(datetime)

                datetime.minute..59
                |> Enum.reduce(guards_min_asleep, fn min, acc ->
                  put_in(acc, Enum.map([cur_guard, today, min], &Access.key(&1, %{})), 0)
                end)
              else
                guards_min_asleep
              end

            {cur_guard, ogma}
        end
      )

    {max_guard_id, _min} =
      guards_day_min_asleep
      |> Enum.reduce(%{}, fn {guard_id, day_min_asleep}, acc ->
        sum =
          Enum.reduce(day_min_asleep, 0, fn {_day, min_asleep}, acc ->
            acc + (min_asleep |> Map.values() |> Enum.sum())
          end)

        Map.put(acc, guard_id, sum)
      end)
      |> Enum.max_by(fn {_, sum} -> sum end)

    {min, _sum} =
      guards_day_min_asleep
      |> Map.get(max_guard_id)
      |> Enum.reduce(%{}, fn {_day, min_asleep}, acc ->
        Enum.reduce(min_asleep, acc, fn {min, value}, acc ->
          Map.put(acc, min, Map.get(acc, min, 0) + value)
        end)
      end)
      |> Enum.max_by(fn {_min, sum} -> sum end)

    max_guard_id * min
  end

  def parse_line(line) do
    # Filter out minutes not between 00:00 and 00:59
    case Regex.scan(@regex, line) do
      [[_, year, month, day, hour, min, "wakes up"]] ->
        [{new_date(year, month, day, hour, min), :wakes_up}]

      [[_, year, month, day, hour, min, "falls asleep"]] ->
        [{new_date(year, month, day, hour, min), :sleep}]

      [[_, year, month, day, hour, min, _, guard]] ->
        [{new_date(year, month, day, hour, min), {:guard, String.to_integer(guard)}}]

      _ ->
        []
    end
  end

  def new_date(year, month, day, hour, min),
    do:
      NaiveDateTime.new!(
        String.to_integer(year),
        String.to_integer(month),
        String.to_integer(day),
        String.to_integer(hour),
        String.to_integer(min),
        0,
        0
      )

  def part2(_args) do
  end
end
