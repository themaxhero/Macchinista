defmodule MacchinistaWeb.Schema.Types do
  use Absinthe.Schema.Notation
  alias MacchinistaWeb.Schema.Types

  import_types(Types.User)
  import_types(Types.Session)
  import_types(Types.CardList)
  import_types(Types.Card)
  import_types(Types.Board)
  import_types(Types.Checklist)
  import_types(Types.Quest)
  import_types(Types.Tag)
end
