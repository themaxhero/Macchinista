defmodule Macchinista.Boards.CardList do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Boards.{ Board, Card }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "card_lists" do
    field :name, :string
    field :order, :integer
    has_many :cards, Card
    belongs_to :board, Board

    timestamps()
  end

  def create_changeset(card_list, attrs) do
    card_list
    |> cast(attrs, [:name])
  end

end
