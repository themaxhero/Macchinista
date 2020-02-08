defmodule Macchinista.Cartello.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Cartello.{Board, Card, CardTag}

  # -----------------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  @type name :: String.t()
  @type color :: String.t()
  @type board :: Board.t()
  @type cards :: [Card.t()]
  @type t :: %__MODULE__{
          name: name,
          color: color,
          board: board,
          cards: cards,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
          optional(:name) => name,
          optional(:color) => color,
          required(:board) => board
        }

  @type update_params :: %{
          optional(:name) => name,
          optional(:color) => color
        }

  @creation_fields ~w/name color/a
  @update_fields ~w/name color/a
  @required_fields ~w/name color board/a

  schema "tags" do
    field :name, :string
    field :color, :string
    belongs_to :board, Board
    many_to_many :cards, Card, join_through: CardTag

    timestamps()
  end

  # -----------------------------------------------------------------------------
  # Getters and Setters
  # -----------------------------------------------------------------------------

  @spec get_name(t) :: name
  def get_name(%__MODULE__{name: name}), do: name

  @spec set_name(type_or_changeset, name) :: changeset
  def set_name(%Ecto.Changeset{data: %__MODULE__{}} = changeset, name),
    do: put_change(changeset, :name, name)

  def set_name(%__MODULE__{} = tag, name) do
    tag
    |> change()
    |> put_change(:name, name)
  end

  @spec get_color(t) :: color
  def get_color(%__MODULE__{color: color}), do: color

  @spec set_color(type_or_changeset, color) :: changeset
  def set_color(%Ecto.Changeset{data: %__MODULE__{}} = changeset, color),
    do: put_change(changeset, :color, color)

  def set_color(%__MODULE__{} = tag, color) do
    tag
    |> change()
    |> put_change(:color, color)
  end

  @spec get_board(t) :: board
  def get_board(%__MODULE__{board: board}), do: board

  @spec set_board(type_or_changeset, board) :: changeset
  def set_board(%Ecto.Changeset{data: %__MODULE__{}} = changeset, board),
    do: put_change(changeset, :board, board)

  def set_board(%__MODULE__{} = tag, %Board{} = board) do
    tag
    |> change()
    |> put_change(:board, board)
  end

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  # -----------------------------------------------------------------------------
  # Changesets
  # -----------------------------------------------------------------------------

  @spec create_changeset(creation_params) :: changeset
  def create_changeset(%{board: board} = attrs) do
    %__MODULE__{}
    |> Macchinista.Repo.preload(:cards)
    |> cast(attrs, @creation_fields)
    |> put_assoc(:board, board)
    |> validate_required(@required_fields)
  end

  @spec update_changeset(t, update_params) :: changeset
  def update_changeset(tag, attrs) do
    tag
    |> Macchinista.Repo.preload(:cards)
    |> cast(attrs, @update_fields)
    |> validate_required(@required_fields)
  end

  # -----------------------------------------------------------------------------
  # Querying
  # -----------------------------------------------------------------------------
  defmodule Query do
    @moduledoc false
    import Ecto.Query

    alias Ecto.Query
    alias Macchinista.Cartello.{Tag, Board, Card}

    @spec by_board(Board.t()) :: Query.t()
    def by_board(%Board{id: id}) do
      from t in Tag,
        where: t.board_id == ^id,
        select: t
    end

    def by_card(%Card{id: id}) do
      Tag
      |> join(:inner, [t], r in "cards_tags", on: r.card_id == ^id and r.tag_id == t.id)
      |> select([t, r], {r.card_id, t})
    end
  end
end
