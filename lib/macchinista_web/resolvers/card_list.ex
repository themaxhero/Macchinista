defmodule MacchinistaWeb.Resolvers.CardList do
  alias Macchinista.Cartello

  def card_lists(_, _, _),
    do: {:ok, []}

  def card_list(_, %{id: id}, _),
    do: Cartello.get_card_list(id)

  def create_card_list(_, args, %{context: %{user: user}}),
    do: Cartello.create_card_list(args, user)
end
