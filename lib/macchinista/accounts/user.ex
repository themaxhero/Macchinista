defmodule Macchinista.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Accounts.PasswordHasher

  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "users" do
    field :username, :string
    field :email, :string, unique: true
    field :password_hash, :string
    field :access_token, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, :string, default: "user"

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation, :role])
    |> validate_required([:username, :email, :password, :password_confirmation, :role])
    |> validate_format(:email, ~r/\S+@\S+\.\S+/)
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password, min: 8, max: 255)
    |> validate_confirmation(:password)
    |> PasswordHasher.hash_password
  end
end
