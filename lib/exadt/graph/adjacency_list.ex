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

  @spec remove_vertex(any) :: :ok
  def remove_vertex(vertex) do
    has_vertex = Agent.get(__MODULE__, fn(map) -> Map.has_key?(map, vertex) end)

    if has_vertex do
      Agent.update(__MODULE__, fn(map) ->
        map
        |> Map.delete(vertex)
        |> Enum.reduce(%{}, fn({key, value}, acc) ->
          Map.put_new(acc, key, List.delete(value, vertex))
        end)
      end)
    else
      nil
    end
  end

  @spec adjacent?(any, any) :: boolean
  def adjacent?(x, y) do
    x_neighbors = Agent.get(__MODULE__, fn(map) ->
      Map.get(map, x)
    end)

    # TODO(lnw): should this case raise an error?
    if x_neighbors == nil do
      false
    else
      Enum.member?(x_neighbors, y)
    end
  end

  @spec neighbors(any) :: [any]
  def neighbors(vertex) do
    Agent.get(__MODULE__, fn(map) -> Map.get(map, vertex) end)
  end

  @spec add_edge(any, any) :: :ok | :error
  def add_edge(x, y) do
    map = Agent.get(__MODULE__, fn(map) -> map end)
    if Map.has_key?(map, x) == false || Map.has_key?(map, y) == false do
      :error
    else
      new_map = map
                |> Map.update!(x, fn(curr_val) -> insert_edge(curr_val, y) end)
                |> Map.update!(y, fn(curr_val) -> insert_edge(curr_val, x) end)

      Agent.update(__MODULE__, fn(_map) -> new_map end)
    end
  end

  @spec insert_edge([any], any) :: [any]
  defp insert_edge(neighbors, new_neighbor) do
    if Enum.member?(neighbors, new_neighbor) do
      neighbors
    else
      [new_neighbor | neighbors]
    end
  end

  @spec remove_edge(any, any) :: :ok
  def remove_edge(x, y) do
    map = Agent.get(__MODULE__, fn(map) -> map end)
    if Map.has_key?(map, x) == false || Map.has_key?(map, y) == false do
      :error
    else
      new_map = map
                  |> Map.update!(x, fn(curr_val) -> List.delete(curr_val,  y) end)
                  |> Map.update!(y, fn(curr_val) -> List.delete(curr_val,  x) end)
      Agent.update(__MODULE__, fn(_map) -> new_map end)
    end
  end
end
