defmodule MacchinistaWeb.Resolvers.Quest do
  alias Macchinista.Cartello

  def quests(_, _, _),
    do: {:ok, []}

  def quest(_, %{id: id}, _),
    do: Cartello.get_quest(id)

  def create_quest(_, args, %{context: %{user: user}}),
    do: Cartello.create_quest(args, user)
end
