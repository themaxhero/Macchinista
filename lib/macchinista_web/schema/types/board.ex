defmodule MacchinistaWeb.Schema.Types.Board do
  use Absinthe.Schema.Notation

  object :board do
    field :id, :id
    field :name, :string
    field :order, :integer
    field :background, :string
    field :user, :user
  end

  input_object :board_input do
    field :name, non_null(:string)
    field :background, :string
  end

  input_object :board_update_input do
    field :id, non_null(:id)
    field :name, :string
    field :background, :string
  end

  input_object :board_delete_input do
    field :id, non_null(:id)
  end
end
