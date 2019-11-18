defmodule Macchinista.Boards.Card do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Boards.{CardList}

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

end
