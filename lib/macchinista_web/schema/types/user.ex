defmodule MacchinistaWeb.Schema.Types.User do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :username, :string
    field :email, :string
    field :access_token, :string
  end

  input_object :user_input do
    field :username, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
  end

end
