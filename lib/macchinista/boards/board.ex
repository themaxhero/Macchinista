defmodule Macchinista.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Accounts.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "boards" do
    field :name, :string
    field :background, :string
    field :order, :integer
    belongs_to :owner, User

    timestamps()
  end

  def create_changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :background, :owner])
  end
end
