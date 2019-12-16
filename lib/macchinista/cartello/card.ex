defmodule Macchinista.Cartello.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias Macchinista.Cartello.{ CardList, Checklist, Tag }

  #-----------------------------------------------------------------------------
  # Setup
  #-----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  @type name :: String.t
  @type description :: String.t
  @type order :: integer()
  @type parent :: String.t
  @type cards :: [Card.t]
  @type card_list :: CardList.t
  @type shelve :: boolean()
  @type tags :: [Tag.t]
  @type t :: %__MODULE__{
    name: name,
    description: description,
    order: order,
    parent: parent,
    cards: cards,
    card_list: card_list,
    tags: tags,
    shelve: shelve,
    inserted_at: NaiveDateTime.t,
    updated_at: NaiveDateTime.t
  }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
    optional(:name) => name,
    optional(:parent) => parent
  }

  @type update_params :: %{
    optional(:name) => name,
    optional(:description) => description,
    optional(:parent) => parent
  }

  @creation_fields ~w/name parent/a
  @update_fields ~w/name description parent/a
  @required_fields ~w//a

  schema "cards" do
    field :name, :string
    field :description, :string
    field :order, :integer
    field :shelve, :boolean
    field :parent, :string
    has_many :cards, __MODULE__
    has_many :checklists, Checklist
    belongs_to :card_list, CardList
    many_to_many :tags, Tag, join_through: "cards_tags", on_replace: :delete

    timestamps()
  end

  #-----------------------------------------------------------------------------
  # Getters and Setters
  #-----------------------------------------------------------------------------

  @spec get_name(t) :: name
  def get_name(%__MODULE__{ name: name }), do: name

  @spec set_name(type_or_changeset, name) :: changeset
  def set_name(%Ecto.Changeset{data: %__MODULE__{}} = changeset, name),
    do: put_change(changeset, :name, name)
  def set_name(%__MODULE__{} = card, name) do
    card
    |> change()
    |> put_change(:name, name)
  end

  @spec get_description(t) :: description
  def get_description(%__MODULE__{ description: description }), do: description

  @spec set_description(type_or_changeset, description) :: changeset
  def set_description(%Ecto.Changeset{data: %__MODULE__{}} = changeset, description),
    do: put_change(changeset, :description, description)
  def set_description(%__MODULE__{} = card, description) do
    card
    |> change()
    |> put_change(:description, description)
  end

  @spec get_parent(t) :: parent
  def get_parent(%__MODULE__{ parent: parent }), do: parent

  @spec set_parent(type_or_changeset, parent) :: changeset
  def set_parent(%Ecto.Changeset{data: %__MODULE__{}} = changeset, parent),
    do: put_change(changeset, :parent, parent)
  def set_parent(%__MODULE__{} = card, parent) do
    card
    |> change()
    |> put_change(:parent, parent)
  end

  @spec get_order(t) :: order
  def get_order(%__MODULE__{ order: order }), do: order

  @spec set_order(type_or_changeset, order) :: changeset
  def set_order(%Ecto.Changeset{data: %__MODULE__{}} = changeset, order),
    do: put_change(changeset, :order, order)
  def set_order(card, order) do
    card
    |> change()
    |> put_change(:order, order)
  end

  @spec get_shelve(t) :: shelve
  def get_shelve(%__MODULE__{ shelve: shelve }), do: shelve

  @spec set_shelve(type_or_changeset, shelve) :: changeset
  def set_shelve(%Ecto.Changeset{data: %__MODULE__{}} = changeset, shelve),
    do: put_change(changeset, :shelve, shelve)
  def set_shelve(%__MODULE__{} = card, shelve) do
    card
    |> change()
    |> put_change(:shelve, shelve)
  end

  @spec get_last_nested_card(t) :: t
  def get_last_nested_card(%__MODULE__{ cards: cards }) do
    cards
    |> Enum.reverse()
    |> List.first()
  end

  @spec get_last_checklist(t) :: Checklist.t
  def get_last_checklist(%__MODULE__{ checklists: checklists }) do
    checklists
    |> Enum.reverse()
    |> List.first()
  end

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Changesets
  #-----------------------------------------------------------------------------

  @spec create_changeset(creation_params) :: changeset
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @creation_fields)
    |> validate_required(@required_fields)
  end

  @spec update_changeset(t, update_params) :: changeset
  def update_changeset(card, attrs) do
    card
    |> cast(attrs, @update_fields)
    |> validate_required(@required_fields)
  end
end
