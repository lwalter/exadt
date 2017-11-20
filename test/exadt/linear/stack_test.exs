defmodule Exadt.Linear.StackTest do
  use ExUnit.Case

  doctest Exadt.Linear.Stack

  alias Exadt.Linear.Stack

  @initial_state %Stack{
    size: 0,
    data: []
  }

  @stack_2_elements %Stack{
    size: 2,
    data: ["b", "a"]
  }

  describe ".start_link" do
    test "inits with an empty array" do
      {:ok, pid} = Stack.start_link

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      assert actual_state == @initial_state
    end
  end

  describe ".push" do
    test "nil returned when nil value provided" do
      {:ok, pid} = Stack.start_link

      result = Stack.push(nil)

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      assert actual_state == @initial_state
      assert result == :error
    end

    test "value pushed onto top of stack" do
      {:ok, pid} = Stack.start_link
      Agent.update(pid, fn(_curr) -> @stack_2_elements end)

      result = Stack.push("c")

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      expected_state = %Stack{
        size: 3,
        data: ["c", "b", "a"]
      }
      assert actual_state == expected_state
      assert result == :ok
    end
  end

  describe ".pop" do
    test ":error returned when stack empty" do
      {:ok, pid} = Stack.start_link

      result = Stack.pop

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      assert actual_state == @initial_state
      assert result == :error
    end

    test "value returned" do
      {:ok, pid} = Stack.start_link
      Agent.update(pid, fn(_curr) -> @stack_2_elements end)

      result = Stack.pop

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      expected_state = %Stack{
        size: 1,
        data: ["a"]
      }
      assert actual_state == expected_state
      assert result == "b"
    end
  end

  describe ".top" do
    test ":error returned when stack empty" do
      {:ok, pid} = Stack.start_link

      result = Stack.top

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      assert actual_state == @initial_state
      assert result == :error
    end

    test "value returned when stack non-empty" do
      {:ok, pid} = Stack.start_link
      Agent.update(pid, fn(_curr) -> @stack_2_elements end)

      result = Stack.top

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      assert actual_state == @stack_2_elements
      assert result == "b"
    end
  end

  describe ".size" do
    test "returns 0 for empty stack" do
      {:ok, pid} = Stack.start_link

      result = Stack.size

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      assert actual_state == @initial_state
      assert result == 0
    end

    test "returns size of stack when non-empty" do
      {:ok, pid} = Stack.start_link
      Agent.update(pid, fn(_curr) -> @stack_2_elements end)

      result = Stack.size

      actual_state = Agent.get(pid, fn(curr) -> curr end)
      assert actual_state == @stack_2_elements
      assert result == 2
    end
  end
end
