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
end
