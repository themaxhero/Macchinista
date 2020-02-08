defmodule MacchinistaWeb.Schema.Types.Tag do
  use Absinthe.Schema.Notation

  object :tag do
    field :name, :string
    field :color, :string
    field :board, :board
    field :cards, list_of(:card)
  end

  input_object :tag_input do
    field :name, :string
    field :color, :string
    field :board_id, non_null(:id)
  end

  input_object :tag_update_input do
    field :id, non_null(:id)
    field :name, :string
    field :color, :string
  end

  input_object :tag_delete_input do
    field :id, non_null(:id)
  end
end
