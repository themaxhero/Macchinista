defmodule Macchinista.Repo.Migrations.AddSessionModel do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :id, null: false
      add :active, :boolean, null: false

      timestamps()
    end
  end
end
