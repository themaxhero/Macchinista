defmodule MacchinistaWeb.Schema do
  use Absinthe.Schema
  alias MacchinistaWeb.Resolvers.User, as: UserResolver
  alias MacchinistaWeb.Resolvers.Session, as: SessionResolver

  import_types(MacchinistaWeb.Schema.Types)

  query do
    field :users, list_of(:user) do
      resolve &UserResolver.users/3
    end
  end

  mutation do
    field :register_user, type: :user do
      arg :input, non_null(:user_input)
      resolve &UserResolver.register_user/3
    end

    field :login, type: :session do
      arg :input, non_null(:login_input)
      resolve &SessionResolver.login/3
    end
  end

  # subscripton do
  # end

end
