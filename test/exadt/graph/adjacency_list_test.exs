defmodule Exadt.Graph.AdjacencyListTest do
  use ExUnit.Case, async: true

  doctest Exadt.Graph.AdjacencyList

  alias Exadt.Graph.AdjacencyList, as: Al

  describe ".start_link" do
    test "inits a new dictionary" do
      {:ok, pid} = Al.start_link

      state = Agent.get(pid, fn(curr) -> curr end)
      assert state == %{}
    end
  end

  describe ".insert_vertex" do
    test "creates a new vertex" do
      {:ok, pid} = Al.start_link()

      Al.insert_vertex("a")

      state = Agent.get(pid, fn(curr) -> curr end)
      assert state == %{"a" => []}
    end

    test "does not overwrite an existing vertex" do
      {:ok, pid} = Al.start_link()

      expected_state = %{"a" => ["b"], "b" => ["a"]}
      Agent.update(pid, fn(_curr) -> expected_state end)

      Al.insert_vertex("a")

      state = Agent.get(pid, fn(curr) -> curr end)
      assert state == expected_state
    end
  end

  describe ".remove_vertex" do
    test "removes a vertex with no edges" do
      {:ok, pid} = Al.start_link

      vertex_to_remove = "a"
      Agent.update(pid, fn(_curr) -> %{vertex_to_remove => []} end)

      Al.remove_vertex(vertex_to_remove)

      state = Agent.get(pid, fn(curr) -> curr end)
      assert state == %{}
    end

    test "removes a vertex with edges" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => ["b"], "b" => ["a", "c"], "c" => ["b"]}
      Agent.update(pid, fn(_curr) -> initial_state end)

      Al.remove_vertex("a")

      state = Agent.get(pid, fn(curr) -> curr end)
      assert state == %{"b" => ["c"], "c" => ["b"]}
    end

    test "removing non-existant vertex returns nil" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => []}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result = Al.remove_vertex("b")
      assert result == nil
    end
  end

  describe ".adjacent" do
    test "returns true when two vertices are adjacent" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => ["b"], "b" => ["a"]}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result = Al.adjacent?("a", "b")
      assert result == true
    end

    test "returns false when two vertices are not adjacent" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => ["b"], "b" => ["a"], "c" => []}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result = Al.adjacent?("a", "c")
      assert result == false
    end

    test "returns false when vertices are not present" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => []}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result = Al.adjacent?("a", "b")
      assert result == false
    end
  end

  describe ".neighbors" do
    test "returns list of neighbors" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => ["b"], "b" => ["a"]}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result = Al.neighbors("a")
      assert result == ["b"]
    end

    test "returns nil if vertex doesnt exist" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => []}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result = Al.neighbors("b")
      assert result == nil
    end
  end

  describe ".add_edge" do
    test "creates an edge between two vertices" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => [], "b" => []}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result = Al.add_edge("a", "b")

      resulting_state = Agent.get(pid, fn(curr) -> curr end)
      expected_state = %{"a" => ["b"], "b" => ["a"]}
      assert result == :ok
      assert resulting_state == expected_state
    end

    test "returns :error when vertices do not exist" do
      {:ok, pid} = Al.start_link

      initial_state = %{"a" => [], "b" => []}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result_1 = Al.add_edge("c", "b")

      resulting_state_1 = Agent.get(pid, fn(curr) -> curr end)
      expected_state = %{"a" => [], "b" => []}
      assert result_1 == :error
      assert resulting_state_1 == expected_state

      result_2 = Al.add_edge("a", "c")

      resulting_state_2 = Agent.get(pid, fn(curr) -> curr end)
      assert result_2 == :error
      assert resulting_state_2 == expected_state
    end
  end

  describe ".remove_edge" do
    test "removes edge from both vertices" do
      {:ok, pid} = Al.start_link
      initial_state = %{"a" => ["b", "c"], "b" => ["a"], "c" => ["a"]}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result = Al.remove_edge("a", "b")

      expected_state = %{"a" => ["c"], "b" => [], "c" => ["a"]}
      actual_state = Agent.get(pid, fn(curr) -> curr end)
      assert result == :ok
      assert actual_state == expected_state
    end

    test "returns :error when vertices do not exist" do
      {:ok, pid} = Al.start_link
      initial_state = %{"a" => ["b"], "b" => ["a"]}
      Agent.update(pid, fn(_curr) -> initial_state end)

      result_1 = Al.remove_edge("c", "b")

      actual_state_1 = Agent.get(pid, fn(curr) -> curr end)
      assert result_1 == :error
      assert actual_state_1 == initial_state

      result_2 = Al.remove_edge("c", "b")

      actual_state_2 = Agent.get(pid, fn(curr) -> curr end)
      assert result_2 == :error
      assert actual_state_2 == initial_state
    end
  end
end
