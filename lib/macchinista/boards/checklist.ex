defmodule Macchinista.Boards.Checklist do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Boards.{ Card, Task }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "checklists" do
    field :name, :string
    field :order, :integer
    field :checked, :boolean
    has_many :tasks, Task
    belongs_to :card, Card

    timestamps()
  end

  def create_changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:name, :checked, :tasks])
  end

end
