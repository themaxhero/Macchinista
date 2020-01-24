defmodule MacchinistaWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Macchinista.Accounts
  alias Macchinista.Accounts.User

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _) do
    IO.inspect(conn)

    case build_context(conn) do
      {:ok, %{user_id: _user_id} = context} ->
        put_private(conn, :absinthe, %{context: context})

      {:ok, %{}} ->
        put_private(conn, :absinthe, %{context: %{}})

      {:error, :invalid_authorization_token} ->
        conn
        |> send_resp(400, "invalid_authorization_token")
        |> halt()
    end
  end

  def build_context(conn) do
    case get_req_header(conn, "authorization") do
      [] ->
        {:ok, %{}}

      [token] ->
        case Accounts.authorize_user(token) do
          {:ok, %User{} = user} ->
            {:ok, %{user_id: user.id}}

          {:error, :invalid_authorization_token} ->
            {:error, :invalid_authorization_token}
        end
    end
  end
end
