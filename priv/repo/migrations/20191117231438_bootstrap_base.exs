defmodule Macchinista.Repo.Migrations.BootstrapBase do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Board"
      add :order, :integer, null: false
      add :background, :string
      add :shelve, :boolean, default: :false
      add :user_id, references(:users, type: :uuid)

      timestamps()
    end
    create unique_index(:boards, [:user_id, :order])

    create table(:tags, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Tag"
      add :color, :string, size: 7
      add :board_id, references(:boards, type: :uuid)

      timestamps()
    end

    create table(:card_lists, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled List"
      add :order, :integer
      add :board_id, references(:boards, type: :uuid)

      timestamps()
    end
    create unique_index(:card_lists, [:board_id, :order])

    create table(:cards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Card"
      add :description, :string
      add :shelve, :boolean, default: :false
      add :order, :integer
      add :parent, references(:cards, type: :uuid)
      add :card_list_id, references(:card_lists, type: :uuid)

      timestamps()
    end
    create unique_index(:cards, [:card_list_id, :order])

    create table(:checklists, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Checklist"
      add :order, :integer
      add :card_id, references(:cards, type: :uuid)

      timestamps()
    end
    create unique_index(:checklists, [:card_id, :order])

    create table(:quests, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Quest"
      add :order, :integer
      add :checked, :boolean, default: false
      add :checklist_id, references(:checklists, type: :uuid)

      timestamps()
    end
    create unique_index(:quests, [:checklist_id, :order])
  end
end
