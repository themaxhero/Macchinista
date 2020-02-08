defmodule MacchinistaWeb.Schema.Types.Checklist do
  use Absinthe.Schema.Notation

  object :checklist do
    field :id, :id
    field :name, :string
    field :quests, list_of(:quest)
    field :card, :card
  end

  input_object :checklist_input do
    field :name, :string
    field :card_id, non_null(:id)
  end

  input_object :checklist_update_input do
    field :id, non_null(:id)
    field :name, :string
  end

  input_object :checklist_delete_input do
    field :id, non_null(:id)
  end

  input_object :reorder_checklist_input do
    field :id, non_null(:id)
    field :order, non_null(:integer)
  end
end
