defmodule Exadt.Graph.AdjacencyListTest do
  use ExUnit.Case, async: true

  doctest Exadt.Graph.AdjacencyList

  alias Exadt.Graph.AdjacencyList, as: Al

  describe ".insert_vertex" do
    test "creates a new vertex" do
      {:ok, pid} = Al.start_link()

      Al.insert_vertex("a")

      state = Agent.get(pid, fn(curr) -> curr end)

      assert state == %{"a" => []}
    end
  end
end
