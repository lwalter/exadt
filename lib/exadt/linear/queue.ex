defmodule Exadt.Linear.Queue do
  @moduledoc """
  A FIFO data structure.
  """

  defstruct [:data, :remove_i]
  alias Exadt.Linear.Queue

  def start_link do
    Agent.start_link(fn() ->
      %Queue{data: [], remove_i: -1}
    end, name: __MODULE__)
  end

  @spec enqueue(any) :: :ok
  def enqueue(nil), do: :error
  def enqueue(value) do
    Agent.update(__MODULE__, fn(queue = %Queue{}) ->
      queue
      |> Map.update!(:data, fn(curr) -> [value | curr] end)
      |> Map.update!(:remove_i, fn(curr) -> curr + 1 end)
    end)
  end

  @spec dequeue() :: any
  def dequeue do
    %Queue{data: data, remove_i: index} = Agent.get(__MODULE__,
                                            fn(queue) -> queue end)
    case do_dequeue(data, index) do
      {:ok, {value, updated_queue}} ->
        Agent.update(__MODULE__, fn(queue) ->
          queue
          |> Map.update!(:data, fn(_curr) -> updated_queue end)
          |> Map.update!(:remove_i, fn(_curr) -> index - 1 end)
        end)
        value
      {:error, _reason} -> nil
    end
  end

  @spec do_dequeue([any], integer) :: {:error, String.t} | {any, [any]}
  defp do_dequeue(_, -1), do: {:error, "Cannot remove from empty queue"}
  defp do_dequeue(data, index) when is_integer(index), do:  {:ok, List.pop_at(data, index)}

  @spec size() :: integer
  def size do
    Agent.get(__MODULE__, fn(%Queue{remove_i: index}) ->
      case index do
        -1 -> 0
        _ -> index + 1
      end
    end)
  end

  @spec is_empty?() :: boolean
  def is_empty?() do
    Agent.get(__MODULE__, fn(%Queue{remove_i: index}) -> index < 1 end)
  end
end
