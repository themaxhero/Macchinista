defmodule Macchinista.Cartello.Board do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias Macchinista.Cartello.{CardList, Tag}
  alias Macchinista.Accounts.{User}

  # -----------------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @type changeset :: %Changeset{data: %__MODULE__{}}

  @type name :: String.t()
  @type background :: String.t()
  @type order :: integer()
  @type card_lists :: [CardList.t()]
  @type user :: User.t()
  @type tags :: [Tag.t()]
  @type users :: [User.t()]
  @type t :: %__MODULE__{
          name: name,
          background: background,
          card_lists: card_lists,
          order: integer(),
          user: user,
          shelve: boolean(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
          optional(:name) => String.t(),
          optional(:background) => String.t(),
          optional(:order) => integer(),
          required(:user) => User
        }

  @type update_params :: %{
          optional(:name) => String.t(),
          optional(:background) => String.t(),
          optional(:user) => User,
          optional(:tags) => Tags
        }

  @creation_fields ~w/name background order/a
  @update_fields ~w/name background order/a
  @required_fields ~w/name background order/a

  schema "boards" do
    field :name, :string
    field :background, :string
    field :shelve, :boolean
    field :order, :integer
    has_many :card_lists, CardList
    has_many :tags, Tag
    belongs_to :user, User

    timestamps()
  end

  # -----------------------------------------------------------------------------
  # Getters and Setters
  # -----------------------------------------------------------------------------

  @spec get_name(t) :: name
  def get_name(%__MODULE__{name: name}), do: name

  @spec set_name(type_or_changeset, name) :: changeset
  def set_name(%Changeset{data: %__MODULE__{}} = changeset, name),
    do: put_change(changeset, :name, name)

  def set_name(%__MODULE__{} = board, name) do
    board
    |> change()
    |> put_change(:name, name)
  end

  @spec get_background(t) :: background()
  def get_background(%__MODULE__{background: background}), do: background

  @spec set_background(type_or_changeset, background) :: changeset
  def set_background(%Changeset{data: %__MODULE__{}} = changeset, background),
    do: put_change(changeset, :background, background)

  def set_background(%__MODULE__{} = board, background) do
    board
    |> change()
    |> put_change(:background, background)
  end

  @spec get_user(t) :: user
  def get_user(%__MODULE__{user: user}), do: user

  @spec get_tags(t) :: tags
  def get_tags(%__MODULE__{tags: tags}), do: tags

  @spec set_user(Board.t() | changeset, user) :: changeset
  def set_user(%Changeset{data: %__MODULE__{}} = changeset, user),
    do: put_change(changeset, :user, user)

  def set_user(%__MODULE__{} = board, %User{} = user) do
    board
    |> change()
    |> put_change(:user, user)
  end

  @spec get_last_card_list(t) :: CardList.t()
  def get_last_card_list(%__MODULE__{card_lists: card_lists}) do
    card_lists
    |> Enum.reverse()
    |> List.first()
  end

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------
  @spec validate_background(:background, binary()) :: Keyword.t()
  def validate_background(:background, value) do
    uri = URI.parse(value)

    (uri.scheme != nil &&
       uri.host =~ "." &&
       []) ||
      [background: "Invalid Background URL"]
  end

  @spec generic_validations(changeset) :: changeset
  def generic_validations(changeset) do
    changeset
    |> validate_required([:name, :background, :user])
    |> validate_length(:name, min: 8, max: 24)
    |> validate_change(:background, &validate_background/2)
  end

  # -----------------------------------------------------------------------------
  # Changesets
  # -----------------------------------------------------------------------------
  @spec create_changeset(creation_params) :: changeset
  def create_changeset(%{user: user} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @creation_fields)
    |> put_assoc(:user, user)
    |> validate_required(@required_fields)
    |> generic_validations()
    |> foreign_key_constraint(:user_id)
  end

  @spec update_changeset(type_or_changeset, update_params) :: changeset
  def update_changeset(%__MODULE__{} = board, attrs) do
    put_assoc_if = fn board_changeset ->
      if Map.has_key?(attrs, :user),
        do: put_assoc(board_changeset, :user, attrs.user),
        else: board_changeset
    end

    board
    |> cast(attrs, @update_fields)
    |> put_assoc_if.()
    |> generic_validations()
  end

  # -----------------------------------------------------------------------------
  # Querying
  # -----------------------------------------------------------------------------
  defmodule Query do
    @moduledoc false
    import Ecto.Query

    alias Ecto.Query
    alias Macchinista.Accounts.User
    alias Macchinista.Cartello.Board

    @spec by_user(User.t()) :: Query.t()
    def by_user(%User{id: id}) do
      from b in Board,
        where: b.user_id == ^id,
        select: b
    end
  end
end
