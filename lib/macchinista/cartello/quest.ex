defmodule Macchinista.Cartello.Quest do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Macchinista.Cartello.Checklist

  #-----------------------------------------------------------------------------
  # Setup
  #-----------------------------------------------------------------------------

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @type changeset :: %Changeset{data: %__MODULE__{}}

  @type name :: String.t
  @type checked :: boolean()
  @type checklist :: Checklist.t
  @type t :: %__MODULE__{
    name: name,
    checked: checked,
    checklist: checklist,
    inserted_at: NaiveDateTime.t,
    updated_at: NaiveDateTime.t
  }
  @type type_or_changeset :: t | changeset

  @type creation_params :: %{
    optional(:name) => name
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
    field :checked, :boolean
    belongs_to :checklist, Checklist

    timestamps()
  end

  #-----------------------------------------------------------------------------
  # Getters and Setters
  #-----------------------------------------------------------------------------

  @spec get_name(t) :: name
  def get_name(%__MODULE__{ name: name }), do: name

  @spec set_name(type_or_changeset, name) :: changeset
  def set_name(%Changeset{ data: %__MODULE__{} } = changeset, name),
    do: put_change(changeset, :name, name)
  def set_name(%__MODULE__{} = quest, name) do
   quest
   |> change()
   |> put_change(:name, name)
  end

  @spec get_checked(t) :: checked
  def get_checked(%__MODULE__{ checked: checked }), do: checked

  @spec set_checked(type_or_changeset, checked) :: changeset
  def set_checked(%Changeset{ data: %__MODULE__{} } = changeset, checked),
    do: put_change(changeset, :checked, checked)
  def set_checked(%__MODULE__{} = quest, checked) do
    quest
    |> change()
    |> put_change(:checked, checked)
  end

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Changesets
  #-----------------------------------------------------------------------------

  @spec create_changeset(creation_params) :: changeset
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @creation_fields)
    |> validate_required(@required_fields)
  end

  @spec update_changeset(t, update_params) :: changeset
  def update_changeset(quest, attrs) do
    quest
    |> cast(attrs, @update_fields)
    |> validate_required(@required_fields)
  end
end
