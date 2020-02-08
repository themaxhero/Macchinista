defmodule Macchinista.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Accounts.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  @creation_params [:user_id, :token, :active]

  @required_fields [:user_id]

  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}
  @type token :: String.t()

  schema "sessions" do
    field :user_id, :integer
    field :token, :string
    field :active, :boolean

    timestamps()
  end

  def create(%User{id: id}) do
    {:ok, %__MODULE__{user_id: id, active: true}}
  end

  def create!(%User{} = user) do
    {:ok, session} = create(user)

    session
  end

  def get_user_id(%__MODULE__{user_id: user_id}), do: user_id

  def inactivate(%__MODULE__{} = session) do
    session
    |> change()
    |> put_change(:active, false)
  end

  @doc false
  def create_changeset(session, attrs) do
    session
    |> cast(attrs, @creation_params)
    |> validate_required(@required_fields)
  end

  defmodule Query do
    import Ecto.Query

    alias Ecto.Query
    alias Macchinista.Accounts.Session

    @spec by_token(Session.token()) :: Query.t()
    def by_token(token) when is_binary(token) do
      from s in Session,
        where: s.token == ^token,
        select: s
    end
  end
end
