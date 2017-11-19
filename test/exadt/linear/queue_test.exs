defmodule Exadt.Linear.QueueTest do
  use ExUnit.Case, async: true

  doctest Exadt.Linear.Queue

  alias Exadt.Linear.Queue

  @initial_state %Queue{data: [], remove_i: -1}

  describe ".start_link" do
    test "inits with empty array and -1 in remove index" do
      {:ok, pid} = Queue.start_link

      curr_state = Agent.get(pid, fn(curr) -> curr end)

      assert curr_state == @initial_state
    end
  end

  describe ".enqueue" do
    test "first enqueue added to array and index updated" do
      {:ok, pid} = Queue.start_link

      result = Queue.enqueue("a")

      curr_state = Agent.get(pid, fn(curr) -> curr end)
      expected_state = %Queue{data: ["a"], remove_i: 0}
      assert result == :ok
      assert curr_state == expected_state
    end

    test "subsequent enqueues added to  array and index updated" do
      {:ok, pid} = Queue.start_link
      Agent.update(pid, fn(_curr) ->
        %Queue{data: ["a"], remove_i: 0}
      end)

      result = Queue.enqueue("b")

      curr_state = Agent.get(pid, fn(curr) -> curr end)
      expected_state = %Queue{data: ["b", "a"], remove_i: 1}
      assert result == :ok
      assert curr_state == expected_state
    end

    test "error returned when nil input provided" do
      {:ok, pid} = Queue.start_link

      result = Queue.enqueue(nil)

      curr_state = Agent.get(pid, fn(curr) -> curr end)
      assert result == :error
      assert curr_state == @initial_state
    end
  end

  describe ".dequeue" do
    test "returns nil when queue empty" do
      {:ok, _pid} = Queue.start_link

      result = Queue.dequeue
      assert result == nil
    end

    test "single element exists - dequeues and updates state to initial" do
      {:ok, pid} = Queue.start_link
      Agent.update(pid, fn(_curr) ->
        %Queue{data: ["a"], remove_i: 0}
      end)

      result = Queue.dequeue
      curr_state = Agent.get(pid, fn(curr) -> curr end)
      assert result == "a"
      assert curr_state == @initial_state
    end

    test "many elements exist - dequeues element and updates state" do
      {:ok, pid} = Queue.start_link
      Agent.update(pid, fn(_curr) ->
        %Queue{data: ["c", "b", "a"], remove_i: 2}
      end)

      result = Queue.dequeue
      curr_state = Agent.get(pid, fn(curr) -> curr end)
      expected_state = %Queue{data: ["c", "b"], remove_i: 1}
      assert result == "a"
      assert curr_state == expected_state
    end
  end

  describe ".size" do
    test "returns 0 when queue empty" do
      {:ok, _pid} = Queue.start_link

      result = Queue.size
      assert result == 0
    end

    test "returns size of non-empty queue" do
      {:ok, pid} = Queue.start_link
      Agent.update(pid, fn(_curr) ->
        %Queue{data: ["b", "a"], remove_i: 1}
      end)

      result = Queue.size
      assert result == 2
    end
  end

  describe ".is_empty?" do
    test "returns true when queue empty" do
      {:ok, _pid} = Queue.start_link

      result = Queue.is_empty?
      assert result == true
    end

    test "returns false when queue is not empty" do
      {:ok, pid} = Queue.start_link
      Agent.update(pid, fn(_curr) ->
        %Queue{data: ["b", "a"], remove_i: 1}
      end)

      result = Queue.is_empty?
      assert result == false
    end
  end
end
