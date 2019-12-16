defmodule Macchinista.Cartello.Checklist do
  use Ecto.Schema
  import Ecto.Changeset

  alias Macchinista.Cartello.{Card, Quest}

  # -----------------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  @type name :: String.t()
  @type order :: integer()
  @type quests :: [Quest.t()]
  @type card :: Card.t()
  @type t :: %__MODULE__{
          name: name,
          order: order,
          quests: quests,
          card: card,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
          optional(:name) => name
        }

  @type update_params :: %{
          optional(:name) => name
        }

  @creation_fields ~w/name/a
  @update_fields ~w/name/a
  @required_fields ~w/name/a

  schema "checklists" do
    field :name, :string
    field :order, :integer
    has_many :quests, Quest
    belongs_to :card, Card

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

  def set_name(%__MODULE__{} = checklist, name) do
    checklist
    |> change()
    |> put_change(:name, name)
  end

  @spec get_order(t) :: order
  def get_order(%__MODULE__{order: order}), do: order

  @spec set_order(type_or_changeset, order) :: changeset
  def set_order(%Ecto.Changeset{data: %__MODULE__{}} = changeset, order),
    do: put_change(changeset, :order, order)

  def set_order(%__MODULE__{} = checklist, order) do
    checklist
    |> change()
    |> put_change(:order, order)
  end

  @spec get_quests(t) :: quests
  def get_quests(%__MODULE__{quests: quests}), do: quests

  @spec set_quests(type_or_changeset, quests) :: changeset
  def set_quests(%Ecto.Changeset{data: %__MODULE__{}} = changeset, quests),
    do: put_change(changeset, :quests, quests)

  def set_quests(%__MODULE__{} = checklist, quests) do
    checklist
    |> change()
    |> put_change(:quests, quests)
  end

  @spec get_card(t) :: card
  def get_card(%__MODULE__{card: card}), do: card

  @spec set_card(type_or_changeset, card) :: changeset
  def set_card(%Ecto.Changeset{data: %__MODULE__{}} = changeset, card),
    do: put_change(changeset, :card, card)

  def set_card(%__MODULE__{} = checklist, card) do
    checklist
    |> change()
    |> put_change(:card, card)
  end

  @spec get_last_quest(t) :: Quest.t()
  def get_last_quest(%__MODULE__{quests: quests}) do
    quests
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
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @creation_fields)
    |> validate_required(@required_fields)
  end

  @spec update_changeset(Checklist.t(), update_params) :: changeset
  def update_changeset(checklist, attrs) do
    checklist
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
    alias Macchinista.Cartello.Card
    alias Macchinista.Cartello.Checklist

    @spec by_card(Card.t()) :: Query.t()
    def by_card(%Card{id: id}) do
      from cl in Checklist,
        where: cl.card_id == ^id,
        select: cl
    end

    @spec by_card_order(Card.t(), Checklist.order()) :: Query.t()
    def by_card_order(%Card{id: id}, order) do
      from cl in Checklist,
        where: cl.card_id == ^id and cl.order == ^order,
        select: cl
    end
  end
end
