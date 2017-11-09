defmodule Exadt.BinarySearchTreeTest do
  use ExUnit.Case, async: true

  doctest Exadt.BinarySearchTree

  alias Exadt.BinarySearchTree, as: Bst

  @leafnode1 %Bst{
    left: :leaf,
    value: 5,
    right: :leaf
  }

  describe ".insert" do
    test "creates a root node" do
      bst = Bst.insert(%Bst{}, 5)
      assert bst == @leafnode1
    end

    test "inserts < value to left" do
      value = @leafnode1.value - 1
      bst = Bst.insert(@leafnode1, value)

      expected_bst = %Bst{
        left: %Bst{
          left: :leaf,
          value: value,
          right: :leaf
        },
        value: @leafnode1.value,
        right: :leaf
      }
      assert bst == expected_bst
    end

    test "inserts > value to the right" do
      value = @leafnode1.value + 1
      bst = Bst.insert(@leafnode1, value)

      expected_bst = %Bst{
        left: :leaf,
        value: @leafnode1.value,
        right: %Bst{
          left: :leaf,
          value: value,
          right: :leaf
        }
      }

      assert bst == expected_bst
    end
  end

  describe ".exists" do
    test "returns false for empty tree" do
      result = Bst.exists(%Bst{}, 1)

      assert result == false
    end

    test "tree depth == 1, returns true when value exists" do
      result = Bst.exists(@leafnode1, @leafnode1.value)

      assert result == true
    end

    test "tree depth == 1, returns false when value does not exist" do
      result = Bst.exists(@leafnode1, @leafnode1.value - 1)

      assert result == false
    end

    @left_node %Bst{
      left: :leaf,
      value: 5,
      right: :leaf
    }
    @right_node %Bst{
      left: :leaf,
      value: 15,
      right: :leaf
    }
    @tree_depth_2 %Bst{
      left: @left_node,
      value: 10,
      right: @right_node
    }
    test "tree depth == 2, returns true when value exists" do
      result = Bst.exists(@tree_depth_2, @left_node.value)

      assert result == true
    end

    test "tree depth == 2, returns false when value does not exist" do
      result = Bst.exists(@tree_depth_2, @right_node.value + 1)

      assert result == false
    end
  end
end
