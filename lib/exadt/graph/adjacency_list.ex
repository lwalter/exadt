defmodule Exadt.Graph.AdjacencyList do
  @moduledoc """

  """

  def start_link do
    Agent.start_link(fn() -> Map.new() end, name: __MODULE__)
  end

  @spec insert_vertex(any) :: :ok
  def insert_vertex(vertex) do
    Agent.update(__MODULE__, fn(map) -> Map.put_new(map, vertex, []) end)
  end

  def adjacent(x, y) do
    Agent.get(__MODULE__, fn(map) ->
      map
      |> Map.get(x)
      |> Enum.member?(y)
    end)
  end

  def neighbors(vertex) do
    Agent.get(__MODULE__, fn(map) -> Map.get(map, vertex) end)
  end

  def add_edge(x, y) do
    Agent.update(__MODULE__, fn(map) ->
      map
      |> Map.update!(x, fn(curr_val) -> insert_edge(curr_val, y) end)
      |> Map.update!(y, fn(curr_val) -> insert_edge(curr_val, x) end)
    end)
  end

  defp insert_edge(neighbors, new_neighbor) do
    if Enum.member?(neighbors, new_neighbor) do
      neighbors
    else
      [new_neighbor | neighbors]
    end
  end
end
