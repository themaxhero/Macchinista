defmodule MacchinistaWeb.Resolvers.CardList do
  alias Macchinista.Cartello

  def card_list(_, %{id: id}, _),
    do: Cartello.get_card_list(id)

  def card_lists(_, _, _),
    do: {:ok, []}
end
