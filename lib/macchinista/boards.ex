defmodule Macchinista.Boards do
  import Ecto.Query, warn: false

  alias Macchinista.Repo
  alias Macchinista.Boards.{ Board, CardList, Card, Checklist, Tag, Task}

  def create_board(user, params) do
    user
    |> Board.new(params)
    |> Repo.insert()
  end

  def update_board(board, params) do
    board
    |> Board.create_changeset(params)
    |> Repo.update()
  end

  def delete_board(board) do
    board
    |> Repo.delete()
  end

  def create_card_list(board, params) do
    board
    |> CardList.new(params)
    |> Repo.insert()
  end

  def update_card_list(card_list, params) do
    card_list
    |> CardList.create_changeset(params)
    |> Repo.update()
  end

  def delete_card_list(card_list) do
    card_list
    |> Repo.delete()
  end

  def create_card(card_list = %CardList{}, params) do
    card_list
    |> Card.new(params)
    |> Repo.insert()
  end

  def create_card(card, = %Card{}, params) do
    card
    |> Card.new(params)
    |> Repo.insert()
  end

  def update_card(card, params) do
    card
    |> Card.create_changeset(params)
    |> Repo.update()
  end

  def delete_card(card) do
    card
    |> Repo.delete()
  end

  def create_checklist(card, params) do
    card
    |> Checklist.new(params)
    |> Repo.insert()
  end

  def update_checklist(card, params) do
    card
    |> Checklist.create_changeset(params)
    |> Repo.update()
  end

  def delete_checklist(card) do
    card
    |> Repo.delete()
  end

  def create_tag(board, params) do
    board
    |> Tag.new(params)
    |> Repo.insert()
  end

  def update_tag(tag, params) do
    tag
    |> Tag.create_changeset(params)
    |> Repo.update()
  end

  def delete_tag(tag) do
    tag
    |> Repo.delete()
  end

  def create_task(checklist, params) do
    checklist
    |> Task.new(params)
    |> Repo.insert()
  end

  def update_task(task, params) do
    task
    |> Task.create_changeset(params)
    |> Repo.update()
  end

  def delete_task(task) do
    task
    |> Repo.delete()
  end
end
