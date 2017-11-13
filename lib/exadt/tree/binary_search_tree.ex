defmodule Exadt.Tree.BinarySearchTree do
  @moduledoc """
  Binary search tree functionality.
  """
  @type t :: module | :leaf
  defstruct [
    :left,
    :value,
    :right
  ]

  alias Exadt.Tree.BinarySearchTree, as: Bst

  @spec new_leaf(integer) :: %Bst{}
  defp new_leaf(value) do
    %Bst{
      left: :leaf,
      value: value,
      right: :leaf
    }
  end

  @spec insert(%Bst{}, integer) :: %Bst{}
  def insert(%Bst{
    left: nil,
    value: nil,
    right: nil
  }, value), do: new_leaf(value)
  def insert(:leaf, value), do: new_leaf(value)
  def insert(bst = %Bst{
              left: left,
              value: current,
              right: right}, value) do

    # TODO(lnw) not tail call optimized
    cond do
      value < current ->
        %Bst{
          left: insert(left, value),
          value: current,
          right: right
        }
      value > current ->
        %Bst{
          left: left,
          value: current,
          right: insert(right, value)
        }
      value == current -> bst
    end
  end

  @spec exists(%Bst{}, integer) :: boolean
  def exists(%Bst{
              left: nil,
              value: nil,
              right: nil
            }, _value), do: false
  def exists(%Bst{
              left: _left,
              value: current,
              right: _right}, value) when value == current, do: true
  def exists(:leaf, _value), do: false
  def exists(%Bst{
              left: left,
              value: current,
              right: _right}, value) when value < current do
    exists(left, value)
  end
  def exists(%Bst{
              left: _left,
              value: current,
              right: right}, value) when value > current do
    exists(right, value)
  end

  @spec delete(%Bst{}, integer) :: %Bst{} | nil
  def delete(:leaf, _value), do: nil
  def delete(bst = %Bst{left: left, value: current_value, right: right}, value) do
    IO.puts("====")
    IO.inspect(bst)
    cond do
      current_value == value -> do_delete(bst)
      current_value < value -> %Bst{
                                  left: left,
                                  value: value,
                                  right: delete(right, value)}
      current_value > value -> %Bst{
                                  left: delete(left, value),
                                  value: value,
                                  right: right}
    end
  end

  # Something off here
  defp do_delete(%Bst{left: :leaf, value: _value, right: :leaf}), do: :leaf
  defp do_delete(%Bst{left: :leaf, value: _value, right: right}), do: right
  defp do_delete(%Bst{left: left, value: _value, right: :leaf}), do: left
  defp do_delete(%Bst{left: left, value: _value, right: right}) do
    min_value = min_value(right)

    {left, min_value, delete(right, min_value)}
  end

  @spec min_value(%Bst{}) :: integer
  def min_value(nil), do: nil
  def min_value(%Bst{left: :leaf, value: value, right: _right}), do: value
  def min_value(%Bst{left: left, value: _current_value, right: _right}) do
    min_value(left)
  end
end
