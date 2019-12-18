defmodule MacchinistaWeb.Resolvers.Board do
  alias Macchinista.Cartello
  alias Macchinista.Cartello.Board

  def boards(_parent, _args, _resolution),
    do: {:ok, []}

  def board(_parent, %{id: id}, _resolution),
    do: Cartello.get_board(id)

  @spec create_board(any, Board.creation_params(), any) ::
          {:error, atom | binary} | {:ok, Macchinista.Cartello.Board.t()}
  def create_board(_parent, args, %{context: %{user: user}}),
    do: Cartello.create_board(args, user)

  def create_board(_parent, _args, _resolution),
    do: {:error, :invalid_parameters}
end
