defmodule MacchinistaWeb.Router do
  use MacchinistaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MacchinistaWeb do
    pipe_through :api
    forward "/graphql", Absinthe.Plug, schema: MacchinistaWeb.Schema
    if Mix.env() == :dev,
      do: forward "/graphiql",  Absinthe.Plug.GraphlQL, schema: MacchinistaWeb.Schema
  end
end
