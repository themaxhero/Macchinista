defmodule MacchinistaWeb.Resolvers.Checklist do
  alias Macchinista.Accounts
  alias Macchinista.Cartello

  def checklists(_, _, _),
    do: {:ok, []}

  def checklist(_, %{id: id}, _),
    do: Cartello.get_checklist(id)

  def create_checklist(_, args, %{context: %{user_id: user_id}}) do
    user = Accounts.get_user!(user_id)

    Cartello.create_checklist(args, user)
  end

  def update_checklist(_, args, %{context: %{user_id: user_id}}) do
    {:ok, checklist} = Cartello.get_checklist(args.id)
    user = Accounts.get_user!(user_id)

    Cartello.update_checklist(checklist, Map.delete(args, :id), user)
  end

  def reorder_checklist(_, %{id: id, order: order}, %{context: %{user_id: user_id}}) do
    {:ok, checklist} = Cartello.get_checklist(id)
    user = Accounts.get_user!(user_id)

    Cartello.reorder_checklist(checklist, order, user)
  end
end
