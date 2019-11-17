defmodule MacchinistaWeb.Schema.Types.Session do
  use Absinthe.Schema.Notation

  object :session do
    field :id, :id
  end

  input_object :login_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

end
