defmodule MacchinistaWeb.Resolvers.Card do
  alias Macchinista.Accounts
  alias Macchinista.Cartello

  def cards(_, _, _),
    do: []

  def card(_, %{id: id}, _),
    do: Cartello.get_card(id)

  def create_card(_, args, %{context: %{user: user}}),
    do: Cartello.create_card(args, user)

  def shelve_card(_, %{id: id}, %{context: %{user_id: user_id}}) do
    {:ok, card} = Cartello.get_card(id)
    user = Accounts.get_user!(user_id)
    Cartello.shelve_card(card, user)
  end

  def move_card(_, %{id: id, order: order, card_list_id: cl_id}, %{context: %{user_id: user_id}}) do
    {:ok, card} = Cartello.get_card(id)
    {:ok, card_list} = Cartello.get_card_list(cl_id)
    user = Accounts.get_user!(user_id)
    Cartello.move_card_to_card_list(card, order, card_list, user)
  end

  def reorder_card(_, %{id: id, order: order}, %{context: %{user_id: user_id}}) do
    {:ok, card} = Cartello.get_card(id)
    user = Accounts.get_user!(user_id)
    Cartello.reorder_card(card, order, user)
  end

  def merge_cards(_, %{card_ids: ids}, %{context: %{user_id: user_id}}) do
    {[:ok], cards} =
      ids
      |> Enum.map(&Cartello.get_card(&1))
      |> Enum.unzip()

    user = Accounts.get_user!(user_id)

    Cartello.merge_cards(cards, user)
  end

  def flatten_card(_, %{id: id}, %{context: %{user_id: user_id}}) do
    {:ok, card} = Cartello.get_card(id)
    user = Accounts.get_user!(user_id)

    Cartello.flatten_card(card, user)
  end

  def update_card(_, args, %{context: %{user_id: user_id}}) do
    {:ok, card} = Cartello.get_card(args.id)
    user = Accounts.get_user!(user_id)

    Cartello.update_card(card, Map.delete(args, :id), user)
  end

  def delete_card(_, %{id: id}, %{context: %{user_id: user_id}}) do
    {:ok, card} = Cartello.get_card(id)
    user = Accounts.get_user!(user_id)

    Cartello.delete_card(card, user)
  end
end
