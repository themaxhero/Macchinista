defmodule Macchinista.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Accounts.{ CardList, User }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "boards" do
    field :name, :string
    field :background, :string
    field :order, :integer
    has_many :card_lists, CardList
    belongs_to :owner, User

    timestamps()
  end

  def get_name(%__MODULE__{ name: name }), do: name

  def set_name(%__MODULE__{} = board, name),
    do: %{ board | name: name }

  def get_background(%__MODULE__{ background: background }), do: background

  def set_background(%__MODULE__{} = board, background),
    do: %{ board | background: background }

  def get_order(%__MODULE__{ order: order }), do: order

  def set_order(%__MODULE__{} = board, order)
    do: %{ board | order: order }

  def get_owner(%__MODULE__{ owner: owner }), do: owner

  def set_owner(%__MODULE__{} = board, owner),
    do: %{ board | owner: owner }

  def create_changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :background, :owner])
  end
end
