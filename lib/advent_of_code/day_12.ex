defmodule AdventOfCode.Day12 do
  def part1(args) do
    {state, grow_rule} =
      parse_args(args)

    process(state, grow_rule, 20)
    |> calc()
  end

  def process(state, grow_rule, n) do
    1..n
    |> Enum.reduce(state, fn _, new_state ->
      {min, max} =
        new_state
        |> Map.filter(fn {_, v} -> v == "#" end)
        |> Map.keys()
        |> Enum.min_max()

      (min - 3)..(max + 3)
      |> Enum.reduce(%{}, fn i, new_new_state ->
        Map.put(new_new_state, i, grow_rule.(i, new_state))
      end)
    end)
  end

  defp parse_args(args) do
    ["initial state: " <> str | rules_str] = String.split(args, "\n", trim: true)

    state =
      str
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {k, v} -> {v, k} end)
      |> Map.new()

    rules_map =
      rules_str
      |> Enum.map(fn r ->
        [expected, res] = String.split(r, " => ", trim: true)
        {expected, res}
      end)
      |> Map.new()

    grow_rule =
      fn i, state ->
        -2..2
        |> Enum.map(fn k -> Map.get(state, i + k, ".") end)
        |> Enum.join()
        |> then(fn str -> Map.get(rules_map, str, ".") end)
      end

    {state, grow_rule}
  end

  def calc(state) do
    state
    |> Enum.flat_map(fn
      {k, "#"} -> [k]
      {_, "."} -> []
    end)
    |> Enum.sum()
  end

  def part2(args) do
    {state, grow_rule} =
      parse_args(args)

    Enum.reduce(1..150, {state, 0}, fn i, {state, last_sum} ->
      state = process(state, grow_rule, 1)

      res = calc(state)

      IO.puts("#{i} : #{res} / #{res - last_sum}")

      {state, res}
    end)

    # observe repetition from step 128 onward
    # step 128 : 12196
    n = 50_000_000_000
    12196 + (n - 128) * 78
  end
end
