defmodule MacchinistaWeb.Resolvers.Board do
  alias Macchinista.Accounts
  alias Macchinista.Cartello
  alias Macchinista.Cartello.Board

  def boards(_parent, _args, _resolution),
    do: {:ok, []}

  def board(_parent, %{id: id}, _resolution),
    do: Cartello.get_board(id)

  @spec create_board(any, Board.creation_params(), any) ::
          {:error, atom | binary} | {:ok, Macchinista.Cartello.Board.t()}

  def create_board(_parent, args, %{context: %{user_id: user_id}}) do
    user = Accounts.get_user!(user_id)

    Cartello.create_board(args, user)
  end

  def create_board(_parent, _args, _),
    do: {:error, "Access Denied"}

  def update_board(_, %{id: id} = args, %{context: %{user_id: user_id}}) do
    {:ok, board} = Cartello.get_board(id)
    user = Accounts.get_user!(user_id)

    Cartello.update_board(board, Map.delete(args, :id), user)
  end

  def update_board(_parent, _args, _),
    do: {:error, "Access Denied"}

  def delete_board(_, %{id: id}, %{context: %{user_id: user_id}}) do
    {:ok, board} = Cartello.get_board(id)
    user = Accounts.get_user!(user_id)

    Cartello.delete_board(board, user)
  end

  def delete_board(_parent, _args, _),
    do: {:error, "Access Denied"}
end
