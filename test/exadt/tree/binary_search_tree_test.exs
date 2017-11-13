defmodule Exadt.Tree.BinarySearchTreeTest do
  use ExUnit.Case, async: true

  doctest Exadt.Tree.BinarySearchTree

  alias Exadt.Tree.BinarySearchTree, as: Bst

  @leafnode1 %Bst{
    left: :leaf,
    value: 5,
    right: :leaf
  }

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

    test "tree depth == 2, returns true when value exists" do
      result = Bst.exists(@tree_depth_2, @left_node.value)

      assert result == true
    end

    test "tree depth == 2, returns false when value does not exist" do
      result = Bst.exists(@tree_depth_2, @right_node.value + 1)

      assert result == false
    end
  end

  describe ".min_value" do
    test "nil tree returns nil" do
      nil_root = %Bst{left: nil, value: nil, right: nil}
      min_val = Bst.min_value(nil_root)
      assert min_val == nil
    end

    test "root only returns root" do
      min_val = Bst.min_value(@leafnode1)

      assert min_val == @leafnode1.value
    end

    test "tree depth 2 left leaf min is returned" do
      min_val = Bst.min_value(@tree_depth_2)

      assert min_val == @left_node.value
    end

    test "tree root min leaf" do
      minimum_value = 5

      tree = %Bst{
        left: :leaf,
        value: minimum_value,
        right: %Bst{
          left: %Bst{
            left: :leaf,
            value: 8,
            right: :leaf
          },
          value: 10,
          right: %Bst{
            left: :leaf,
            value: 15,
            right: :leaf
          }
        }
      }

      actual_min_val = Bst.min_value(tree)

      assert actual_min_val == minimum_value
    end
  end

  describe ".delete" do
    test "root node deleted" do
      bst = Bst.delete(@leafnode1, @leafnode1.value)

      assert bst == nil
    end

    test "left leaf deleted" do
      bst = Bst.delete(@tree_depth_2, @tree_depth_2.left.value)

      expected_bst = %Bst{
        left: :leaf,
        value: @tree_depth_2.value,
        right: @right_node
      }

      assert expected_bst == bst
    end
  end
end
