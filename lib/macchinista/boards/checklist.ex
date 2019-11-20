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

  def get_name(%__MODULE__{ name: name }), do: name

  def set_name(%__MODULE__{} = checklist, name),
    do: %{ checklist | name: name }

  def get_order(%__MODULE__{ order: order}), do: order

  def set_order(%__MODULE__{} = checklist, order),
    do: %{ checklist | order: order }

  def get_checked(%__MODULE__{ checked: checked }), do: checked

  def set_checked(%__MODULE__{}, checked),
    do: %{ checklist | checked: checked }

  def get_tasks(%__MODULE__{ tasks: tasks }), do: tasks

  def set_tasks(%__MODULE__{} = checklist, tasks),
    do: %{ checklist | tasks: tasks }

  def get_card(%__MODULE__{ card: card }), do: card

  def set_card(%__MODULE__{} = checklist, card),
    do: %{ checklist | card: card }

  def create_changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:name, :checked, :tasks])
  end

end
