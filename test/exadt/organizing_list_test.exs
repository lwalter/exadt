defmodule Exadt.OrganizingListTest do
  use ExUnit.Case, async: true

  doctest Exadt.OrganizingList

  alias Exadt.OrganizingList, as: Ol

  @list [1, 5, 10]

  describe ".insert" do
    test "element inserted into empty array" do
      list = Ol.insert([], 5)

      assert list == [5]
    end

    test "element inserted into front of array" do
      list = Ol.insert(@list, 11)

      assert list == [11 | @list]
    end
  end

  describe ".get" do
    test "existing value returned and moved to front of list" do
      {value, new_list} = Ol.get(@list, 10)

      assert value == 10
      assert new_list == [10, 1, 5]
    end

    test "nil returned when no value found" do
      {value, new_list} = Ol.get(@list, 100)

      assert value == nil
      assert new_list == @list
    end
  end

  describe ".delete" do
    test "false returned when element does not exist" do
      {value_deleted, new_list} = Ol.delete(@list, 100)

      assert value_deleted == false
      assert new_list == @list
    end

    test "true returned when element exists and is removed from resulting list" do
      {value_deleted, new_list} = Ol.delete(@list, 5)

      assert value_deleted == true
      assert new_list == [1, 10]
    end
  end
end
