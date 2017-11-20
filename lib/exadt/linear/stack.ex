defmodule Exadt.Linear.Stack do
  defstruct [:size, :data]

  alias Exadt.Linear.Stack

  def start_link do
    Agent.start_link(fn() -> %Stack{size: 0, data: []} end, name: __MODULE__)
  end

  @spec push(any) :: :ok | :error
  def push(nil), do: :error
  def push(value) do
    Agent.update(__MODULE__, fn(stack = %Stack{}) ->
      stack
      |> Map.update!(:data, fn(curr) -> [value | curr] end)
      |> Map.update!(:size, fn(size) -> size + 1 end)
    end)
  end

  @spec pop() :: any | :error
  def pop do
    Agent.get_and_update(__MODULE__, &do_pop/1)
  end

  def do_pop(stack = %Stack{size: 0}), do: {:error, stack}
  def do_pop(stack = %Stack{data: [head | _tail]}) do
    updated_stack = stack
                      |> Map.update!(:data, fn([_head | tail]) -> tail end)
                      |> Map.update!(:size, fn(size) -> size - 1 end)
    {head, updated_stack}
  end

  @spec top() :: any | :error
  def top do
    Agent.get(__MODULE__, fn(stack = %Stack{}) ->
      {value, _stack} = do_pop(stack)
      value
    end)
  end

  @spec size() :: integer
  def size do
    Agent.get(__MODULE__, fn(%Stack{size: size}) -> size end)
  end
end
