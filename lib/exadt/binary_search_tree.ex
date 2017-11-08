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

  @spec insert(%Bst{}, integer) :: %Bst{}
  def insert(:leaf, value) do
    %Bst{
      left: :leaf,
      value: value,
      right: :leaf
    }
  end
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
  # exists
end
