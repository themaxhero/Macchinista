defmodule MacchinistaWeb.Resolvers.CardList do
  alias Macchinista.Accounts
  alias Macchinista.Cartello

  def card_lists(_, _, _),
    do: {:ok, []}

  def card_list(_, %{id: id}, _),
    do: Cartello.get_card_list(id)

  def create_card_list(_, args, %{context: %{user_id: user_id}}) do
    user = Accounts.get_user!(user_id)

    Cartello.create_card_list(args, user)
  end

  def create_card_list(_parent, _args, _context),
    do: {:error, "Access Denied"}

  def update_card_list(_, %{id: id} = args, %{context: %{user_id: user_id}}) do
    {:ok, card_list} = Cartello.get_card_list(id)
    user = Accounts.get_user!(user_id)

    Cartello.update_card_list(card_list, Map.delete(args, :id), user)
  end

  def update_card_list(_parent, _args, _context),
    do: {:error, "Access Denied"}

  def delete_card_list(_, %{id: id}, %{context: %{user_id: user_id}}) do
    {:ok, card_list} = Cartello.get_card_list(id)
    user = Accounts.get_user!(user_id)

    Cartello.delete_card_list(card_list, user)
  end
  def delete_card_list(_parent, _args, _context),
    do: {:error, "Access Denied"}

  # def move_card_list(_, args, %{context: %{user_id: user_id}}) do
  #   user = Cartello.get_user!(user_id)
  #   Cartello.move_card_list()
  # end
end
