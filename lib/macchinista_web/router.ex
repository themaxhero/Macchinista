defmodule MacchinistaWeb.Router do
  use MacchinistaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug MacchinistaWeb.Context
  end

  scope "/api" do
    pipe_through :api
    forward "/graphql", Absinthe.Plug, schema: MacchinistaWeb.Schema

    if Mix.env() == :dev,
      do: forward("/graphiql", Absinthe.Plug.GraphiQL, schema: MacchinistaWeb.Schema)
  end
end
