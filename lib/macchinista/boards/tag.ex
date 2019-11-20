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

  def get_name(%__MODULE__{ name: name }), do: name

  def set_name(%__MODULE__{} = tag, name),
    do: %{ tag | name: name }

  def get_color(%__MODULE__{ color: color }), do: color

  def set_color(%__MODULE__{} = tag, color),
    do: %{ tag | color: color }

  def get_board(%__MODULE__{ board: board }), do: booard

  def set_board(%__MODULE__{} = tag, board),
    do: %{ tag | board: board }

  def create_changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:name, :color])
  end

end
