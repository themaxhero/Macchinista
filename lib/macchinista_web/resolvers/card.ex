defmodule MacchinistaWeb.Resolvers.Card do
  alias Macchinista.Cartello

  def cards(_, _, _),
    do: []

  def card(_, %{id: id}, _),
    do: Cartello.get_card(id)

  def create_card(_, args, %{context: %{user: user}}),
    do: Cartello.create_card(args, user)
end
