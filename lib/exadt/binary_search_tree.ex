defmodule Exadt.BinarySearchTree do
  @moduledoc """
  Binary search tree functionality.
  """
  @type t :: module | :leaf
  defstruct [
    :left,
    :value,
    :right
  ]

  alias Exadt.BinarySearchTree, as: Bst

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

  # remove
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
end
