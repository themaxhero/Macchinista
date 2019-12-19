defmodule MacchinistaWeb.Resolvers.Quest do
  alias Macchinista.Accounts
  alias Macchinista.Cartello

  def quests(_, _, _),
    do: {:ok, []}

  def quest(_, %{id: id}, _),
    do: Cartello.get_quest(id)

  def create_quest(_, args, %{context: %{user_id: user_id}}) do
    user = Accounts.get_user!(user_id)
    Cartello.create_quest(args, user)
  end

  def reorder_quest(_, %{id: id, order: order}, %{context: %{user_id: user_id}}) do
    {:ok, quest} = Cartello.get_quest(id)
    user = Accounts.get_user!(user_id)

    Cartello.reorder_quest(quest, order, user)
  end
end
