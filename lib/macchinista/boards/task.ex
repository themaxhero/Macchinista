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

  def get_name(%__MODULE__{ name: name }), do: name

  def set_name(%__MODULE__{} = task, name),
    do: %{ task | name: name }

  def get_checked(%__MODULE__{ checked: checked }), do: checked

  def set_checked(%__MODULE__{} = task, checked),
    do: %{ task | checked: checked }

  def create_changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :checked])
  end

end
