defmodule MacchinistaWeb.Schema.Types.Card do
  use Absinthe.Schema.Notation

  object :card do
    field :id, :id
    field :name, :string
    field :description, :string
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

  input_object :card_update_input do
    field :id, non_null(:id)
    field :name, :string
    field :description, :string
    field :shelve, :boolean
    field :parent, :id
  end

  input_object :card_delete_input do
    field :id, non_null(:id)
  end

  input_object :shelve_card_input do
    field :id, non_null(:id)
  end

  input_object :move_card_input do
    field :id, non_null(:id)
    field :parent_id, :id
    field :card_list_id, :id
  end

  input_object :reorder_card_input do
    field :id, non_null(:id)
    field :order, non_null(:integer)
  end

  input_object :merge_cards_input do
    field :cards_id, non_null(list_of(:id))
  end

  input_object :flatten_card_input do
    field :id, non_null(:id)
  end
end
