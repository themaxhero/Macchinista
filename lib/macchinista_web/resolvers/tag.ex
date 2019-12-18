defmodule MacchinistaWeb.Resolvers.Tag do
  alias Macchinista.Cartello

  def tags(_, _, _),
    do: {:ok, []}

  def tag(_, %{id: id}, _),
    do: Cartello.get_tag(id)

  def create_tag(_, args, %{context: %{user: user}}),
    do: Cartello.create_tag(args, user)
end
