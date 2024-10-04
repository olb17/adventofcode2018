defmodule AdventOfCode.Day13 do
  def part1(args) do
    {map, carts} =
      parse_config(args)

    {x, y} = play_carts(map, carts)
    "#{x},#{y}"
  end

  def play_carts(map, carts) do
    carts
    |> Enum.sort_by(fn cart -> {elem(cart.pos, 1), elem(cart.pos, 0)} end)
    |> move_carts([], map)
    |> case do
      {:all_moved, moved_carts} -> play_carts(map, moved_carts)
      {:collision, target} -> target
    end
  end

  def move_carts([], moved_carts, _), do: {:all_moved, moved_carts}

  def move_carts([cart | rest], moved_carts, map) do
    {x, y} = cart.pos
    {dx, dy} = cart.dir
    target = {x + dx, y + dy}

    Enum.concat(rest, moved_carts)
    |> Enum.map(& &1.pos)
    |> Enum.find(&(&1 == target))
    |> case do
      nil ->
        {dir, next_move} =
          case map[target] do
            "-" ->
              {cart.dir, cart.next_move}

            "|" ->
              {cart.dir, cart.next_move}

            "/" ->
              {{-dy, -dx}, cart.next_move}

            "\\" ->
              {{dy, dx}, cart.next_move}

            "+" ->
              case cart.next_move do
                :left -> {{dy, -dx}, :straight}
                :straight -> {{dx, dy}, :right}
                :right -> {{-dy, dx}, :left}
              end
          end

        move_carts(
          rest,
          [%{cart | pos: target, dir: dir, next_move: next_move} | moved_carts],
          map
        )

      _ ->
        {:collision, target}
    end
  end

  def play_carts_crash(map, carts) do
    carts
    |> Enum.sort_by(fn cart -> {elem(cart.pos, 1), elem(cart.pos, 0)} end)
    |> move_carts_crash([], map)
    |> case do
      {:all_moved, [survivor]} ->
        survivor.pos

      {:all_moved, moved_carts} ->
        play_carts_crash(map, moved_carts)
    end
  end

  def move_carts_crash([], moved_parts, _), do: {:all_moved, moved_parts}

  def move_carts_crash([cart | rest], moved_carts, map) do
    {x, y} = cart.pos
    {dx, dy} = cart.dir
    target = {x + dx, y + dy}

    Enum.concat(rest, moved_carts)
    |> Enum.map(& &1.pos)
    |> Enum.find(&(&1 == target))
    |> case do
      nil ->
        {dir, next_move} =
          case map[target] do
            "-" ->
              {cart.dir, cart.next_move}

            "|" ->
              {cart.dir, cart.next_move}

            "/" ->
              {{-dy, -dx}, cart.next_move}

            "\\" ->
              {{dy, dx}, cart.next_move}

            "+" ->
              case cart.next_move do
                :left -> {{dy, -dx}, :straight}
                :straight -> {{dx, dy}, :right}
                :right -> {{-dy, dx}, :left}
              end
          end

        move_carts_crash(
          rest,
          [%{cart | pos: target, dir: dir, next_move: next_move} | moved_carts],
          map
        )

      _ ->
        rest =
          rest
          |> Enum.filter(&(&1.pos != target))

        moved_carts =
          moved_carts
          |> Enum.filter(&(&1.pos != target))

        move_carts_crash(rest, moved_carts, map)
    end
  end

  defp parse_config(args) do
    {map, cart} =
      args
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.flat_map(fn {char, j} ->
          case char do
            "^" ->
              [[type: :map, pos: {j, i}, char: "|"], [type: :cart, pos: {j, i}, dir: {0, -1}]]

            ">" ->
              [[type: :map, pos: {j, i}, char: "-"], [type: :cart, pos: {j, i}, dir: {1, 0}]]

            "v" ->
              [[type: :map, pos: {j, i}, char: "|"], [type: :cart, pos: {j, i}, dir: {0, 1}]]

            "<" ->
              [[type: :map, pos: {j, i}, char: "-"], [type: :cart, pos: {j, i}, dir: {-1, 0}]]

            " " ->
              []

            char ->
              [[type: :map, pos: {j, i}, char: char]]
          end
        end)
      end)
      |> Enum.split_with(fn object -> Keyword.fetch!(object, :type) == :map end)

    {map |> Enum.map(fn [type: :map, pos: pos, char: char] -> {pos, char} end) |> Map.new(),
     cart |> Enum.map(fn data -> make_cart(data) end)}
  end

  def make_cart(data) do
    [type: :cart, pos: pos, dir: dir] = data
    %{pos: pos, dir: dir, next_move: :left}
  end

  def part2(args) do
    {map, carts} =
      parse_config(args)

    {x, y} = play_carts_crash(map, carts)
    "#{x},#{y}"
  end
end
