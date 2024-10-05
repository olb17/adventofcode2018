defmodule AdventOfCode.Day13 do
  def part1(args), do: process(args, &find_crash/2)
  def part2(args), do: process(args, &find_survivor/2)

  def process(args, fun) do
    # map is a dict of {x,y} -> track char ("|", "-", "\\", "/" , "+")
    # carts is a list of %{pos: {x, y}, dir: {dx, dy}, next_move: next_move} where next_move is in :eft, :straight or :right
    {map, carts} = parse_config(args)
    {x, y} = fun.(map, carts)
    "#{x},#{y}"
  end

  def find_crash(map, carts) do
    carts
    |> Enum.sort_by(fn cart -> {elem(cart.pos, 1), elem(cart.pos, 0)} end)
    |> move_carts([], map)
    |> case do
      {:all_moved, moved_carts} -> find_crash(map, moved_carts)
      {:collision, target} -> target
    end
  end

  def collision?(position, cart_list_list) do
    Enum.concat(cart_list_list)
    |> Enum.map(& &1.pos)
    |> Enum.find(&(&1 == position)) != nil
  end

  def move_carts([], moved_carts, _), do: {:all_moved, moved_carts}

  def move_carts([cart | rest], moved_carts, map) do
    {x, y} = cart.pos
    {dx, dy} = cart.dir

    target = {x + dx, y + dy}

    if collision?(target, [rest, moved_carts]) do
      {:collision, target}
    else
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

      new_cart = %{cart | pos: target, dir: dir, next_move: next_move}
      move_carts(rest, [new_cart | moved_carts], map)
    end
  end

  def find_survivor(map, carts) do
    carts
    |> Enum.sort_by(fn cart -> {elem(cart.pos, 1), elem(cart.pos, 0)} end)
    |> move_carts_crash([], map)
    |> case do
      {:all_moved, [survivor]} ->
        # Survivor found
        survivor.pos

      {:all_moved, moved_carts} ->
        find_survivor(map, moved_carts)
    end
  end

  def move_carts_crash([], moved_carts, _), do: {:all_moved, moved_carts}

  def move_carts_crash([cart | rest], moved_carts, map) do
    {x, y} = cart.pos
    {dx, dy} = cart.dir
    target = {x + dx, y + dy}

    if collision?(target, [rest, moved_carts]) do
      # if collision, the current cart and the collided one are removed from processing
      rest = rest |> Enum.filter(&(&1.pos != target))
      moved_carts = moved_carts |> Enum.filter(&(&1.pos != target))

      move_carts_crash(rest, moved_carts, map)
    else
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

      new_cart = %{cart | pos: target, dir: dir, next_move: next_move}
      move_carts_crash(rest, [new_cart | moved_carts], map)
    end
  end

  defp parse_config(args) do
    {map_points, cart_points} =
      args
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(&parse_line/1)
      |> Enum.split_with(fn object -> Keyword.fetch!(object, :type) == :map end)

    map =
      map_points
      |> Enum.map(fn [type: :map, pos: pos, char: char] -> {pos, char} end)
      |> Map.new()

    carts = cart_points |> Enum.map(fn data -> make_cart(data) end)
    {map, carts}
  end

  @doc """
  parses a line of map and returns an array of points:
  `[type: :map, pos: {j, i}, char: "|"]`
  `[type: :cart, pos: {j, i}, dir: {0, -1}]`
  """
  def parse_line({line, i}) do
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
  end

  def make_cart(data) do
    [type: :cart, pos: pos, dir: dir] = data
    %{pos: pos, dir: dir, next_move: :left}
  end
end
