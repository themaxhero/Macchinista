defmodule Macchinista.Cartello.CardTag do
  use Ecto.Schema
  alias Macchinista.Cartello.{Card, Tag}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "cards_tags" do
    belongs_to :card, Card
    belongs_to :tag, Tag
  end
end
