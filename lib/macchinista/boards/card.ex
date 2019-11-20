defmodule Macchinista.Boards.Card do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Repo
  alias Macchinista.Boards.{ CardList }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "cards" do
    field :name, :string
    field :description, :string
    field :order, :integer
    field :parent, :string
    belongs_to :card_list, CardList

    timestamps()
  end

  def create_changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :parent])
  end

  def get(card_id) do
    card_id
    |> Repo.get()
  end

  def get_name(%__MODULE__{ name: name }), do: name

  def set_name(%__MODULE__{} = card, name),
    do: %{ card | name: name }

  def get_description(%__MODULE__{ description: description }), do: description

  def set_description((%__MODULE__{} = card, description),
    do: %{ card | description: description}

  def get_order(%__MODULE__{ order: order } = card), do: order

  def set_order(card, order),
    do: %{ card | order: order }

  def move(%__MODULE__{ card_list: parent_list } = card, %CardList{} = card_list, position) do
    parent_list
    |> CardList.dissasoc_card(card)
    |> &CardList.assoc_card(card_list, &1, position).()
  end

  def move(%__MODULE__{ card_list: parent_list } = card, parent_list, position),
    do: card

  def update(card_id = String.t, params) do
    card_id
    |> Repo.get()
    |> create_changeset(params)
    |> Repo.update()
  end

  def update(card = %Card{}, params) do
    card
    |> create_changeset(params)
    |> Repo.update()
  end
end
