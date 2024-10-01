defmodule AdventOfCode.Day08 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> parse_node()
    |> dbg
    |> then(fn {_, node} -> compute_metas(node) end)
  end

  defp parse_node(incoming) do
    [nb_nodes | [nb_meta | rest]] = incoming

    {rest, nodes} =
      if nb_nodes > 0 do
        Enum.reduce(1..nb_nodes, {rest, []}, fn _, {rest2, nodes} ->
          {rest3, node} = parse_node(rest2)
          {rest3, [node | nodes]}
        end)
      else
        {rest, []}
      end

    {metas, rest} = Enum.split(rest, nb_meta)
    {rest, %{nodes: nodes, metas: metas}}
  end

  defp compute_metas(node) do
    a =
      Enum.reduce(node.nodes, 0, fn node, acc ->
        acc + compute_metas(node)
      end)

    b = Enum.sum(node.metas)

    a + b
  end

  def part2(_args) do
  end
end
