defmodule MacchinistaWeb.Resolvers.Tag do
  alias Macchinista.Accounts
  alias Macchinista.Cartello

  def tags(_, _, _),
    do: {:ok, []}

  def tag(_, %{id: id}, _),
    do: Cartello.get_tag(id)

  def create_tag(_, args, %{context: %{user_id: user_id}}) do
    user = Accounts.get_user!(user_id)

    Cartello.create_tag(args, user)
  end

  def create_tag(_parent, _args, _context),
    do: {:error, "Access Denied"}

  def update_tag(_, %{id: id} = args, %{context: %{user_id: user_id}}) do
    {:ok, tag} = Cartello.get_tag(id)
    user = Accounts.get_user!(user_id)

    Cartello.update_tag(tag, Map.delete(args, :id), user)
  end

  def update_tag(_parent, _args, _context),
    do: {:error, "Access Denied"}

  def delete_tag(_, %{id: id}, %{context: %{user_id: user_id}}) do
    {:ok, tag} = Cartello.get_tag(id)
    user = Accounts.get_user!(user_id)

    Cartello.delete_tag(tag, user)
  end

  def delete_tag(_parent, _args, _context),
    do: {:error, "Access Denied"}
end
