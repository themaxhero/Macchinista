defmodule MacchinistaWeb.Schema.Types.CardList do
  use Absinthe.Schema.Notation

  object :card_list do
    field :id, :id
    field :name, :string
    field :order, :integer
    field :cards, list_of(:card)
    field :board, :board
  end

  input_object :card_list_input do
    field :name, :string
    field :board_id, non_null(:id)
  end

  input_object :card_list_update_input do
    field :id, non_null(:id)
    field :name, :string
  end

  input_object :card_list_delete_input do
    field :id, non_null(:id)
  end

  input_object :move_card_list_input do
    field :id, non_null(:id)
    field :order, non_null(:integer)
  end

  input_object :reorder_card_list_input do
    field :id, non_null(:id)
    field :order, non_null(:integer)
  end
end
