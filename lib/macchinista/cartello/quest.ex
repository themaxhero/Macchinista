defmodule Macchinista.Cartello.Quest do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Macchinista.Cartello.Checklist

  # -----------------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @type changeset :: %Changeset{data: %__MODULE__{}}

  @type name :: String.t()
  @type checked :: boolean()
  @type checklist :: Checklist.t()
  @type order :: integer()
  @type t :: %__MODULE__{
          name: name,
          checked: checked,
          order: order,
          checklist: checklist,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
          optional(:name) => name,
          required(:checklist) => checklist
        }

  @type update_params :: %{
          optional(:name) => name,
          optional(:checked) => checked
        }

  @creation_fields ~w/name/a
  @update_fields ~w/name checked/a
  @required_fields ~w//a

  schema "quests" do
    field :name, :string
    field :order, :integer
    field :checked, :boolean
    belongs_to :checklist, Checklist

    timestamps()
  end

  # -----------------------------------------------------------------------------
  # Getters and Setters
  # -----------------------------------------------------------------------------

  @spec get_name(t) :: name
  def get_name(%__MODULE__{name: name}), do: name

  @spec set_name(type_or_changeset, name) :: changeset
  def set_name(%Changeset{data: %__MODULE__{}} = changeset, name),
    do: put_change(changeset, :name, name)

  def set_name(%__MODULE__{} = quest, name) do
    quest
    |> change()
    |> put_change(:name, name)
  end

  @spec get_order(t) :: order
  def get_order(%__MODULE__{order: order}), do: order

  @spec set_order(type_or_changeset, order) :: changeset
  def set_order(%Changeset{data: %__MODULE__{}} = changeset, order),
    do: put_change(changeset, :order, order)

  def set_order(%__MODULE__{} = quest, order) do
    quest
    |> change()
    |> put_change(:order, order)
  end

  @spec get_checked(t) :: checked
  def get_checked(%__MODULE__{checked: checked}), do: checked

  @spec set_checked(type_or_changeset, checked) :: changeset
  def set_checked(%Changeset{data: %__MODULE__{}} = changeset, checked),
    do: put_change(changeset, :checked, checked)

  def set_checked(%__MODULE__{} = quest, checked) do
    quest
    |> change()
    |> put_change(:checked, checked)
  end

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  # -----------------------------------------------------------------------------
  # Changesets
  # -----------------------------------------------------------------------------

  @spec create_changeset(creation_params) :: changeset
  def create_changeset(%{checklist: checklist} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @creation_fields)
    |> put_assoc(:checklist, checklist)
    |> validate_required(@required_fields)
  end

  @spec update_changeset(t, update_params) :: changeset
  def update_changeset(quest, attrs) do
    quest
    |> cast(attrs, @update_fields)
    |> validate_required(@required_fields)
  end
end
