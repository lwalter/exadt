defmodule Exadt.OrganizingList do
  @moduledoc """
  Self-organizing list imeplementation. Implementation applies the
  [Move to Front method](https://en.wikipedia.org/wiki/Self-organizing_list).

  For a count heuristic implementation something to retain state will be needed.
  GenServer, Agent?
  """

  @spec insert([any], any) :: [any]
  def insert(list, value) do
    [value | list]
  end

  @spec get([any], any) :: {any | nil, [any]}
  def get(list, value) do
    index = Enum.find_index(list, fn(n) -> n == value end)
    cond do
      index == nil -> {nil, list}
      index == 0 -> {value, list}
      index > 0 ->
        new_list = list
          |> List.delete_at(index)
          |> List.insert_at(0, value)

        {value, new_list}
    end
  end

  @spec delete([any], any) :: {boolean, [any]}
  def delete(list, value) do
    index = Enum.find_index(list, fn(n) -> n == value end)

    if index == nil do
      {false, list}
    else
      {true, List.delete_at(list, index)}
    end
  end
end
