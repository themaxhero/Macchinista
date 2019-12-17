defmodule MacchinistaWeb.Resolvers.Board do
  alias Macchinista.Cartello

  def boards(_parent, _args, _resolution),
    do: {:ok, []}

  def board(_parent, %{id: id}, _resolution),
    do: Cartello.get_board(id)

  def create_board(_parent, args, %{context: %{user: user}}) do
    Cartello.create_board(args, user)
  end

  def create_board(_parent, _args, _resolution),
    do: {:error, :invalid_parameters}
end
