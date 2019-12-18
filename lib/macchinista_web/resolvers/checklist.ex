defmodule MacchinistaWeb.Resolvers.Checklist do
  alias Macchinista.Cartello

  def checklists(_, _, _),
    do: {:ok, []}

  def checklist(_, %{id: id}, _),
    do: Cartello.get_checklist(id)

  def create_checklist(_, args, %{context: %{user: user}}),
    do: Cartello.create_checklist(args, user)
end
