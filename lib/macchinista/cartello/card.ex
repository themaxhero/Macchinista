defmodule Macchinista.Cartello.Card do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Cartello.{CardList, Checklist, Tag, CardTag}

  # -----------------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  @type name :: String.t()
  @type description :: String.t()
  @type order :: integer()
  @type parent :: t() | nil
  @type cards :: [Card.t()]
  @type card_list :: CardList.t()
  @type shelve :: boolean()
  @type checklists :: [Checklist.t()]
  @type tags :: [Tag.t()]
  @type t :: %__MODULE__{
          name: name,
          description: description,
          order: order,
          parent: parent,
          card_id: String.t(),
          cards: cards,
          card_list: card_list,
          checklists: checklists,
          tags: tags,
          shelve: shelve,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
          optional(:name) => name,
          optional(:parent) => parent,
          required(:order) => order,
          required(:card_list) => CardList.t(),
          optional(:parent) => parent
        }

  @type update_params :: %{
          optional(:name) => name,
          optional(:description) => description,
          optional(:shelve) => shelve,
          optional(:order) => order,
          optional(:parent) => parent,
          optional(:tags) => tags
        }

  @creation_fields ~w/name order/a
  @update_fields ~w/name description order parent_id/a
  @required_fields ~w/card_list/a
  @required_update_fields ~w//a

  schema "cards" do
    field :name, :string
    field :description, :string
    field :order, :integer
    field :shelve, :boolean
    belongs_to :parent, __MODULE__
    has_many :cards, __MODULE__
    field :card_id, Ecto.UUID, source: :parent_id
    has_many :checklists, Checklist
    belongs_to :card_list, CardList, references: :id, on_replace: :update
    many_to_many :tags, Tag, join_through: CardTag

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

  def set_name(%__MODULE__{} = card, name) do
    card
    |> change()
    |> put_change(:name, name)
  end

  @spec get_description(t) :: description
  def get_description(%__MODULE__{description: description}), do: description

  @spec set_description(type_or_changeset, description) :: changeset
  def set_description(%Ecto.Changeset{data: %__MODULE__{}} = changeset, description),
    do: put_change(changeset, :description, description)

  def set_description(%__MODULE__{} = card, description) do
    card
    |> change()
    |> put_change(:description, description)
  end

  @spec get_parent(t) :: parent
  def get_parent(%__MODULE__{parent: parent}), do: parent

  @spec set_parent(type_or_changeset, parent) :: changeset
  def set_parent(%Ecto.Changeset{data: %__MODULE__{}} = changeset, parent),
    do: put_change(changeset, :parent, parent)

  def set_parent(%__MODULE__{} = card, parent) do
    card
    |> change()
    |> put_change(:parent, parent)
  end

  @spec get_order(t) :: order
  def get_order(%__MODULE__{order: order}), do: order

  @spec set_order(type_or_changeset, order) :: changeset
  def set_order(%Ecto.Changeset{data: %__MODULE__{}} = changeset, order),
    do: put_change(changeset, :order, order)

  def set_order(%__MODULE__{} = card, order) do
    card
    |> change()
    |> put_change(:order, order)
  end

  @spec get_shelve(t) :: shelve
  def get_shelve(%__MODULE__{shelve: shelve}), do: shelve

  @spec set_shelve(type_or_changeset, shelve) :: changeset
  def set_shelve(%Ecto.Changeset{data: %__MODULE__{}} = changeset, shelve),
    do: put_change(changeset, :shelve, shelve)

  def set_shelve(%__MODULE__{} = card, shelve) do
    card
    |> change()
    |> put_change(:shelve, shelve)
  end

  @spec get_cards(t) :: cards
  def get_cards(%__MODULE__{cards: cards}), do: cards

  @spec get_checklists(t) :: checklists
  def get_checklists(%__MODULE__{checklists: checklists}), do: checklists

  @spec get_card_list(t) :: CardList.t()
  def get_card_list(%__MODULE__{card_list: card_list}), do: card_list

  @spec set_card_list(type_or_changeset, CardList.t()) :: changeset
  def set_card_list(card, card_list) do
    card
    |> change
    |> put_change(:card_list_id, card_list.id)
  end

  @spec get_last_nested_card(t) :: t | nil
  def get_last_nested_card(%__MODULE__{cards: cards}) do
    cards
    |> Enum.reverse()
    |> List.first()
  end

  @spec get_last_checklist(t) :: Checklist.t() | nil
  def get_last_checklist(%__MODULE__{checklists: checklists}) do
    checklists
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
  def create_changeset(%{card_list: card_list, parent: parent} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @creation_fields)
    |> put_assoc(:card_list, card_list)
    |> put_assoc(:parent, parent)
    |> validate_required(@required_fields)
    |> unique_constraint(:unique_cards, name: :cards_card_list_id_order_shelve_parent_id_index)
  end

  def create_changeset(%{card_list: card_list} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @creation_fields)
    |> put_assoc(:card_list, card_list)
    |> validate_required(@required_fields)
    |> unique_constraint(:unique_cards, name: :cards_card_list_id_order_shelve_parent_id_index)
  end

  @spec update_changeset(t, update_params) :: changeset
  def update_changeset(card, attrs) do
    card =
      card
      |> Macchinista.Repo.preload(:parent)
      |> Macchinista.Repo.preload(:cards)
      |> Macchinista.Repo.preload(:checklists)
      |> Macchinista.Repo.preload(:tags)

    tags =
      if Map.has_key?(attrs, :tags),
        do: attrs.tags ++ card.tags,
        else: card.tags

    card
    |> cast(attrs, @update_fields)
    |> put_assoc(:tags, tags)
    |> validate_required(@required_update_fields)
    |> unique_constraint(:unique_cards, name: :cards_card_list_id_order_shelve_parent_id_index)
    |> unique_constraint(:unique_tags, name: :card_id_tag_id_unique_index)
  end

  # -----------------------------------------------------------------------------
  # Querying
  # -----------------------------------------------------------------------------
  defmodule Query do
    import Ecto.Query

    alias Ecto.Query
    alias Macchinista.Cartello.{Card, CardList, Tag}

    @spec by_card_list_and_order_gt(CardList.t(), Card.order()) :: Query.t()
    def by_card_list_and_order_gt(%CardList{id: id}, order) do
      from c in Card,
        where: c.card_list_id == ^id and c.order > ^order,
        select: c
    end

    def by_tags(%Tag{id: id}) do
      Card
      |> join(:inner, [c], r in "cards_tags", on: r.tag_id == ^id and r.card_id == c.id)
      |> select([c, r], {r.tag_id, c})
    end
  end
end
