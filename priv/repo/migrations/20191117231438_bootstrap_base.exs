defmodule Macchinista.Repo.Migrations.BootstrapBase do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Board"
      add :order, :integer, null: false
      add :background, :string
      add :owner, references(:users, type: :uuid)

      timestamps()
    end
    create unique_index(:boards, [:owner, :order])

    create table(:tags, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Tag"
      add :color, :string, size: 7
      add :order, :integer
      add :board, references(:boards, type: :uuid)

      timestamps()
    end
    create unique_index(:tags, [:board, :order])

    create table(:card_lists, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled List"
      add :order, :integer
      add :board, references(:boards, type: :uuid)

      timestamps()
    end
    create unique_index(:card_lists, [:board, :order])

    create table(:cards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Card"
      add :description, :string
      add :order, :integer
      add :parent, references(:cards)
      add :card_list, references(:card_lists, type: :uuid)

      timestamps()
    end
    create unique_index(:cards, [:card_list, :order])

    create table(:checklists, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Checklist"
      add :order, :integer
      add :card, references(:cards, type: :uuid)

      timestamps()
    end
    create unique_index(:checklists, [:card, :order])

    create table(:tasks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: "Untitled Task"
      add :order, :integer
      add :checked, :boolean, default: false
      add :checklist, references(:checklists, type: :uuid)

      timestamps()
    end
    create unique_index(:tasks, [:checklist, :order])

  end
end
