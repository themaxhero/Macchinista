defmodule Macchinista.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Accounts.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "sessions" do
    field :user_id, :integer
    field :active, :boolean

    timestamps()
  end

  def new(%User{id: id}) do
    {:ok, %__MODULE__{user_id: id, active: true}}
  end

  def new!(%User{id: id}) do
    %__MODULE__{user_id: id, active: true}
  end

  @doc false
  def create_changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id, :id, :active])
    |> validate_required([:user_id])
  end
end
