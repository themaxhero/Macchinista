defmodule Macchinista.Boards.CardList do
  use Ecto.Schema
  import Ecto.Changeset
  import Macchinista.Macros
  alias Macchinista.Repo
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

  def get_name(%__MODULE__{ name: name}), do: name

  def set_name(%__MODULE__{} = card_list, name),
    do: %{ card_list | name: name }

  def get_cards(%__MODULE__{ cards: cards } = card_list), do: cards

  def set_cards(%__MODULE__{} = card_list, cards),
    do: %{ card_list | cards: cards }

  def get_order(%__MODULE__{ order: order } = card_list), do: order

  def set_order(%__MODULE__{} = card_list, order),
    do: %{ card_list | order: order }

  def get_board(%__MODULE__{ board: board }), do: board

  def set_board(%__MODULE__{} = card_list, %Board{} = board),
    do: %{ card_list | board: board }

  def create_changeset(card_list, attrs) do
    card_list
    |> cast(attrs, [:name])
  end

  defp assoc_reducer(%Card{} = elem, {acc, index, card, position}) do
    if index == position do
      card =
        Card.set_order card position
      acc =
        [ card | acc ]
    end
    elem =
      Card.set_order elem index

    { [ elem | acc ], index + 1, card, position }
  end

  def assoc_card(%__MODULE__{ cards: cards } = card_list, card, position) do
    { updated_cards, _, _, _ } =
      cards
      |> Enum.reduce({[], 0, card, position}, &assoc_reducer/2)

      card_list
      |> set_cards(updated_cards)
  end

  def disassoc_card(%__MODULE__{ cards: cards } = card_list, %Card{id: id}) do
    cards =
      cards
      |> Enum.filter(fn card -> card.id != id end)

    set_cards card_list cards
  end

  def disassoc_card(%__MODULE__{ cards: cards } = card_list, String.t = card_id) do
    cards =
      cards
      |> Enum.filter(fn card -> card.id != card_id end)

    set_cards card_list cards
  end

  def disassoc_card(_, _),
    do: {:error, :invalid_parameters}

end
