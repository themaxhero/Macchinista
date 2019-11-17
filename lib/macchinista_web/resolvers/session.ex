defmodule MacchinistaWeb.Resolvers.Session do
  alias Macchinista.Accounts
  def login(_, %{input: input}, _),
    do: Accounts.login(input)
end
