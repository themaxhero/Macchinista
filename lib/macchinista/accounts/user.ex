defmodule Macchinista.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Macchinista.Cartello.Board

  # -----------------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @type changeset :: %Changeset{data: %__MODULE__{}}
  @type username :: String.t()
  @type email :: String.t()
  @type password_hash :: String.t()
  @type access_token :: String.t()
  @type role :: String.t()
  @type boards :: [Board.t()]
  @type t :: %__MODULE__{
          username: username,
          email: email,
          password_hash: password_hash,
          access_token: access_token,
          role: role
        }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
          username: username,
          email: email,
          password: String.t(),
          password_confirmation: String.t(),
          boards: boards
        }

  @type update_params :: %{
          optional(:email) => email,
          optional(:password) => String.t(),
          optional(:password_confirmation) => String.t()
        }

  @creation_fields ~w/username email password password_confirmation role/a
  @update_fields ~w/email password password_confirmation/a
  @required_fields ~w/username email password password_confirmation role/a

  schema "users" do
    field :username, :string
    field :email, :string, unique: true
    field :password_hash, :string
    field :access_token, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, :string, default: "user"
    has_many :boards, Board

    timestamps()
  end

  # -----------------------------------------------------------------------------
  # Getters and Setters
  # -----------------------------------------------------------------------------

  @spec get_username(t) :: username
  def get_username(%__MODULE__{username: username}),
    do: username

  @spec set_username(type_or_changeset, username) :: changeset
  def set_username(%Ecto.Changeset{data: %__MODULE__{}} = changeset, username),
    do: put_change(changeset, :username, username)

  def set_username(%__MODULE__{} = user, username) do
    user
    |> change()
    |> put_change(:username, username)
  end

  @spec get_email(t) :: email
  def get_email(%__MODULE__{email: email}),
    do: email

  @spec set_email(type_or_changeset, email) :: changeset
  def set_email(%Ecto.Changeset{data: %__MODULE__{}} = changeset, email),
    do: put_change(changeset, :email, email)

  def set_email(%__MODULE__{} = user, email) do
    user
    |> change()
    |> put_change(:email, email)
  end

  @spec get_password_hash(t) :: password_hash
  def get_password_hash(%__MODULE__{password_hash: password_hash}),
    do: password_hash

  @spec set_password_hash(type_or_changeset, password_hash) :: changeset
  def set_password_hash(%Ecto.Changeset{data: %__MODULE__{}} = changeset, password_hash),
    do: put_change(changeset, :password_hash, password_hash)

  def set_password_hash(%__MODULE__{} = user, password_hash) do
    user
    |> change()
    |> put_change(:password_hash, password_hash)
  end

  @spec get_access_token(t) :: access_token
  def get_access_token(%__MODULE__{access_token: access_token}),
    do: access_token

  @spec set_access_token(type_or_changeset, access_token) :: changeset
  def set_access_token(%Ecto.Changeset{data: %__MODULE__{}} = changeset, access_token),
    do: put_change(changeset, :access_token, access_token)

  def set_access_token(%__MODULE__{} = user, e) do
    user
    |> change()
    |> put_change(:e, e)
  end

  @spec get_role(t) :: role
  def get_role(%__MODULE__{role: role}),
    do: role

  @spec set_role(type_or_changeset, role) :: changeset
  def set_role(%Ecto.Changeset{data: %__MODULE__{}} = changeset, role),
    do: put_change(changeset, :role, role)

  def set_role(%__MODULE__{} = user, role) do
    user
    |> change()
    |> put_change(:role, role)
  end

  # -----------------------------------------------------------------------------
  #
  # -----------------------------------------------------------------------------
  @spec put_password_hash(changeset) :: changeset
  def put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    update_changeset = &Ecto.Changeset.put_change(changeset, :password_hash, &1)

    password
    |> Bcrypt.Base.hash_password(Bcrypt.gen_salt(4, true))
    |> update_changeset.()
  end

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------
  @spec validate_email(:email, String.t()) :: [{:email, String.t()}]
  def validate_email(:email, value) do
    if String.match?(value, ~r/\S+@\S+\.\S+/), do: [], else: [email: "Invalid Email Format"]
  end

  # -----------------------------------------------------------------------------
  # Changesets
  # -----------------------------------------------------------------------------

  @spec create_changeset(creation_params) :: changeset
  def create_changeset(attrs) do
    %__MODULE__{}
    |> Macchinista.Repo.preload(:boards)
    |> cast(attrs, @creation_fields)
    |> validate_required(@required_fields)
    |> validate_change(:email, &validate_email/2)
    |> update_change(:email, &String.downcase(&1))
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 8, max: 255)
    |> put_password_hash
  end

  @spec update_changeset(t, creation_params) :: changeset
  def update_changeset(user, attrs) do
    user
    |> Macchinista.Repo.preload(:boards)
    |> cast(attrs, @update_fields)
    |> validate_required(@required_fields)
    |> validate_change(:email, &validate_email/2)
    |> update_change(:email, &String.downcase(&1))
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 8, max: 255)
    |> put_password_hash
  end

  # -----------------------------------------------------------------------------
  # Querying
  # -----------------------------------------------------------------------------
  defmodule Query do
    @moduledoc false
    import Ecto.Query

    alias Ecto.Query
    alias Macchinista.Accounts.User

    @spec by_email(String.t()) :: Query.t()
    def by_email(email) do
      from u in User,
        where: u.email == ^email,
        select: u
    end
  end
end
