defmodule MacchinistaWeb.Resolvers.Checklist do
  alias Macchinista.Cartello

  def checklists(_, _, _),
    do: []

  def checklist(_, %{id: id}, _),
    do: Cartello.get_checklist(id)
end
