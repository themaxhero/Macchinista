defmodule Macchinista.Boards.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Boards.{ Board }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "tags" do
    field :name, :string
    field :color, :string
    belongs_to :board, Board

    timestamps()
  end

  def create_changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:name, :color])
  end

end
