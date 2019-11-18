defmodule Macchinista.Boards.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Macchinista.Boards.{ Checklist }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Ecto.Changeset{data: %__MODULE__{}}

  schema "tasks" do
    field :name, :string
    field :checked, :boolean
    belongs_to :checklist, Checklist

    timestamps()
  end

  def create_changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :checked])
  end

end
