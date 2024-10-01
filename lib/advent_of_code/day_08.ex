defmodule AdventOfCode.Day08 do
  def part1(args), do: find_sol(args, &compute_metas/1)

  def part2(args), do: find_sol(args, &compute_node/1)

  defp find_sol(args, compute) do
    args
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> parse_node()
    |> then(fn {_, node} -> compute.(node) end)
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
    {rest, %{nodes: nodes |> Enum.reverse(), metas: metas}}
  end

  defp compute_metas(node) do
    Enum.reduce(node.nodes, Enum.sum(node.metas), fn node, acc ->
      acc + compute_metas(node)
    end)
  end

  defp compute_node(nil), do: 0

  defp compute_node(node) when length(node.nodes) == 0 do
    Enum.sum(node.metas)
  end

  defp compute_node(node) do
    Enum.reduce(node.metas, 0, fn meta, acc ->
      acc + compute_node(Enum.at(node.nodes, meta - 1))
    end)
  end
end
