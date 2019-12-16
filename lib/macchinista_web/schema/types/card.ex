defmodule MacchinistaWeb.Schema.Types.Card do
  use Absinthe.Schema.Notation

  object :card do
    field :id, :id
    field :name, :string
    field :order, :integer
    field :shelve, :boolean
    field :parent, :card
    field :cards, list_of(:card)
    field :checklists, list_of(:checklist)
    field :card_list, :card_list
    field :tags, list_of(:tag)
  end

  input_object :card_input do
    field :name, :string
    field :card_list_id, non_null(:id)
  end
end
