defmodule Macchinista.Cartello.CardList do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Cartello.{Board, Card}

  # -----------------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  @type name :: String.t()
  @type order :: integer()
  @type cards :: [Card.t()]
  @type board :: Board.t()
  @type t :: %__MODULE__{
          name: name,
          order: order,
          cards: cards,
          shelve: boolean(),
          board: board,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
          optional(:name) => name,
          required(:order) => order,
          required(:board) => board
        }

  @type update_params :: %{
          optional(:name) => name,
          optional(:shelve) => boolean(),
          optional(:order) => order
        }

  @creation_fields ~w/name order/a
  @update_fields ~w/name shelve order/a
  @required_fields ~w/board order/a

  schema "card_lists" do
    field :name, :string
    field :order, :integer
    field :shelve, :boolean, default: false
    has_many :cards, Card
    belongs_to :board, Board, on_replace: :update

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

  def set_name(%__MODULE__{} = card_list, name) do
    card_list
    |> change()
    |> put_change(:name, name)
  end

  @spec get_cards(t) :: cards
  def get_cards(%__MODULE__{cards: cards}), do: cards

  @spec set_cards(type_or_changeset, cards) :: changeset
  def set_cards(%Ecto.Changeset{data: %__MODULE__{}} = changeset, cards),
    do: put_change(changeset, :cards, cards)

  def set_cards(%__MODULE__{} = card_list, cards) do
    card_list
    |> change()
    |> put_change(:cards, cards)
  end

  @spec get_order(t) :: order
  def get_order(%__MODULE__{order: order}), do: order

  @spec set_order(type_or_changeset, order) :: changeset
  def set_order(%Ecto.Changeset{data: %__MODULE__{}} = changeset, order),
    do: put_change(changeset, :order, order)

  def set_order(%__MODULE__{} = card_list, order) do
    card_list
    |> change()
    |> put_change(:order, order)
  end

  @spec get_board(t) :: board
  def get_board(%__MODULE__{board: board}), do: board

  @spec set_board(type_or_changeset, board) :: changeset
  def set_board(%Ecto.Changeset{data: %__MODULE__{}} = changeset, board),
    do: put_change(changeset, :board, board)

  def set_board(%__MODULE__{} = card_list, %Board{} = board) do
    card_list
    |> change()
    |> put_change(:board_id, board.id)
  end

  @spec get_last_card(t) :: Card.t()
  def get_last_card(card_list) do
    card_list
    |> get_cards()
    |> Enum.reverse()
    |> List.first()
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
    |> unique_constraint(:unique_card_lists, name: :card_lists_board_id_order_shelve_index)
  end

  @spec update_changeset(t, update_params) :: changeset
  def update_changeset(%__MODULE__{} = card_list, attrs) do
    card_list
    |> Macchinista.Repo.preload(:cards)
    |> cast(attrs, @update_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:unique_card_lists, name: :card_lists_board_id_order_shelve_index)
  end

  # -----------------------------------------------------------------------------
  # Querying
  # -----------------------------------------------------------------------------

  defmodule Query do
    @moduledoc false
    import Ecto.Query

    alias Ecto.Query
    alias Macchinista.Cartello.{CardList, Board}

    @spec by_board_order(Board.t(), CardList.order()) :: Query.t()
    def by_board_order(%Board{id: board_id}, order) do
      from cl in CardList,
        where: cl.board_id == ^board_id and cl.order == ^order,
        select: cl
    end

    @spec by_board_order_gt(Board.t(), CardList.order()) :: Query.t()
    def by_board_order_gt(%Board{id: board_id}, order) do
      from cl in CardList,
        where: cl.board_id == ^board_id and cl.order > ^order,
        select: cl
    end

    @spec by_board_name(Board.t(), CardList.name()) :: Query.t()
    def by_board_name(%Board{id: board_id}, name) do
      from cl in CardList,
        where: cl.board_id == ^board_id and cl.name == ^name,
        select: cl
    end
  end
end
