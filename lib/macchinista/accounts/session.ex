defmodule Macchinista.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Accounts.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  @creation_params [:user_id, :id, :active]

  @required_fields [:user_id]

  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "sessions" do
    field :user_id, :integer
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
end
