defmodule Macchinista.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password_hash, :string
      add :access_token, :string
      add :role, :string

      timestamps()
    end

  end
end
