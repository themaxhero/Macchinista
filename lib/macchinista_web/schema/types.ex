defmodule MacchinistaWeb.Schema.Types do
  use Absinthe.Schema.Notation
  alias MacchinistaWeb.Schema.Types

  import_types(Types.User)
  import_types(Types.Session)
end
