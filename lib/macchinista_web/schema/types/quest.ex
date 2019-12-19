defmodule MacchinistaWeb.Schema.Types.Quest do
  use Absinthe.Schema.Notation

  object :quest do
    field :name, :string
    field :checked, :boolean
    field :order, :integer
    field :checklist, :checklist
  end

  input_object :quest_input do
    field :name, :string
    field :checklist_id, non_null(:id)
  end

  input_object :quest_update_input do
    field :id, non_null(:id)
    field :name, :string
    field :checked, :boolean
  end

  input_object :quest_delete_input do
    field :id, non_null(:id)
  end
end
