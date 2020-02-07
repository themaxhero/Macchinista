defmodule Macchinista.CartelloTest do
  use ExUnit.Case

  alias Macchinista.Accounts
  alias Macchinista.Cartello
  alias Accounts.{User}
  alias Cartello.{Board, Card, Checklist}
  alias Macchinista.Repo

  describe "Card" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Macchinista.Repo)

      user_creation_params = %{
        username: "test",
        email: "test@domain.com",
        password: "tectectectec",
        password_confirmation: "tectectectec",
        boards: []
      }

      {:ok, user} = Accounts.create_user(user_creation_params)

      board_creation_params = %{
        name: "Testing Board",
        background: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
        user: user,
        order: 0
      }

      {:ok, board} = Cartello.create_board(board_creation_params, user)

      card_list_creation_params = %{
        name: "Testing Card List",
        board: board
      }

      {:ok, card_list} = Cartello.create_card_list(card_list_creation_params, user)

      card_list_creation_params_2 = %{
        name: "Testing Card List 2",
        board: board
      }

      {:ok, card_list_2} = Cartello.create_card_list(card_list_creation_params_2, user)

      {:ok, %{user: user, card_list: card_list, card_list_2: card_list_2, board: board}}
    end

    test "Creating", %{user: user, card_list: card_list} do
      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      assert card.name == "Testing Card"
      assert card.order == 0
      assert card.card_list == card_list
      assert card.parent == nil
    end

    test "Moving", %{card_list: card_list, card_list_2: card_list_2, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      {:ok, cards} = Cartello.move_card_to_card_list(card, 1, card_list_2, user)

      card = Enum.find(cards, fn c -> c.id == card.id end)

      refute card == nil
      assert card.card_list_id == card_list_2.id
      assert card.order == 1
    end

    test "Reordering", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      card_creation_params_2 = %{
        name: "Testing Card 2",
        order: 1,
        card_list: card_list
      }

      {:ok, card_2} = Cartello.create_card(card_creation_params_2, user)

      {:ok, cards} = Cartello.reorder_card(card_2, 0, user)

      card = Enum.find(cards, fn c -> c.id == card.id end)
      card_2 = Enum.find(cards, fn c -> c.id == card_2.id end)

      refute card == nil
      refute card_2 == nil
      assert card.order == 1
      assert card_2.order == 0
      assert card.card_list_id == card_list.id
      assert card_2.card_list_id == card_list.id
    end

    test "Renaming", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      update_params = %{
        name: "Tested Card"
      }

      {:ok, card} = Cartello.update_card(card, update_params, user)

      assert card.name == "Tested Card"
    end

    test "Editing Description", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      update_params = %{
        description: "Card's description"
      }

      {:ok, card} = Cartello.update_card(card, update_params, user)

      assert card.description == "Card's description"
    end

    test "Shelving", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      {:ok, card} = Cartello.shelve_card(card, user)

      assert card.shelve == true
    end

    test "Assigning", %{card_list: card_list, user: user, board: board} do
      tag_creation_params = %{
        name: "Game",
        color: "#990000",
        board: board
      }

      {:ok, tag} = Cartello.create_tag(tag_creation_params, user)

      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      update_params = %{
        tags: [tag]
      }

      {:ok, card} =
        card
        |> Card.update_changeset(update_params)
        |> Repo.update()

      got_tag = Enum.find(card.tags, fn found_tag -> found_tag.id == tag.id end)

      refute got_tag == nil
      assert got_tag.id == tag.id
    end
  end

  describe "Checklist" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Macchinista.Repo)

      user_creation_params = %{
        username: "test",
        email: "test@domain.com",
        password: "tectectectec",
        password_confirmation: "tectectectec",
        boards: []
      }

      {:ok, user} = Accounts.create_user(user_creation_params)

      board_creation_params = %{
        name: "Testing Board",
        background: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
        user: user,
        order: 0
      }

      {:ok, board} = Cartello.create_board(board_creation_params, user)

      card_list_creation_params = %{
        name: "Testing Card List",
        board: board
      }

      {:ok, card_list} = Cartello.create_card_list(card_list_creation_params, user)

      card_creation_params = %{
        name: "Card Test",
        description: "Card bem louco mesmo",
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      checklist_creation_params = %{
        name: "Tarefas",
        card: card
      }

      {:ok, checklist} = Cartello.create_checklist(checklist_creation_params, user)

      {:ok, %{user: user, card: card, checklist: checklist}}
    end

    test "Creating", %{user: user, card: card} do
      checklist_creation_params = %{
        name: "Tarefas",
        card: card
      }

      {:ok, checklist} = Cartello.create_checklist(checklist_creation_params, user)

      refute checklist == nil
      assert checklist.name == "Tarefas"
      assert checklist.card_id == card.id
    end

    test "Renaming", %{user: user, checklist: checklist} do
      checklist_update_params = %{
        name: "TODOS"
      }

      {:ok, checklist} = Cartello.update_checklist(checklist, checklist_update_params, user)

      refute checklist == nil
      assert checklist.name == "TODOS"
    end

    test "Reordering" do
    end

    test "Deleting", %{checklist: checklist, user: user} do
      checklist = Repo.preload(checklist, :card)

      {:ok, checklist} = Cartello.delete_checklist(checklist, user)

      card = Checklist.get_card(checklist)
      card_id = card.id

      {:ok, card} = Cartello.get_card(card_id)

      card = Repo.preload(card, :checklists)

      checklist_id = checklist.id
      checklists = Card.get_checklists(card)

      refute Enum.find(checklists, fn checklist -> checklist.id == checklist_id end)
    end
  end

  describe "Quest" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Macchinista.Repo)

      # checklist: checklist, quest: quest
      {:ok, %{}}
    end

    test "Creating" do
    end

    test "Activating" do
    end

    test "Reordering" do
    end

    test "Deleting" do
    end
  end

  describe "Board" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Macchinista.Repo)

      user_creation_params = %{
        username: "test",
        email: "test@domain.com",
        password: "tectectectec",
        password_confirmation: "tectectectec",
        boards: []
      }

      {:ok, user} = Accounts.create_user(user_creation_params)

      board_creation_params = %{
        name: "Testing Board",
        background: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
        user: user,
        order: 0
      }

      {:ok, board} = Cartello.create_board(board_creation_params, user)

      {:ok, %{user: user, board: board}}
    end

    test "Creating", %{user: user} do
      board_creation_params = %{
        name: "Testing Board",
        background: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
        user: user,
        order: 1
      }

      {:ok, board} = Cartello.create_board(board_creation_params, user)

      refute board == nil
      assert board.name == "Testing Board"

      assert board.background ==
               "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg"

      assert board.user_id == user.id
      assert board.order == 1
    end

    test "Deleting", %{board: board, user: user} do
      board_id = board.id
      {:ok, _board} = Cartello.delete_board(board, user)

      boards =
        user.id
        |> Accounts.get_user!()
        |> Repo.preload(:boards)
        |> User.get_boards()

      refute Enum.find(boards, fn board -> board.id == board_id end)
    end

    test "Renaming", %{user: user, board: board} do
      board_update_params = %{
        name: "Board loucão mesmo"
      }

      {:ok, board} = Cartello.update_board(board, board_update_params, user)

      assert board.name == "Board loucão mesmo"
    end

    test "Background Changing", %{user: user, board: board} do
      board_update_params = %{
        background:
          "https://image.freepik.com/free-vector/digital-systems-that-are-calculating-data_49459-519.jpg"
      }

      {:ok, board} = Cartello.update_board(board, board_update_params, user)

      assert board.background ==
               "https://image.freepik.com/free-vector/digital-systems-that-are-calculating-data_49459-519.jpg"
    end
  end

  describe "Tag" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Macchinista.Repo)

      user_creation_params = %{
        username: "test",
        email: "test@domain.com",
        password: "tectectectec",
        password_confirmation: "tectectectec",
        boards: []
      }

      {:ok, user} = Accounts.create_user(user_creation_params)

      board_creation_params = %{
        name: "Testing Board",
        background: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
        user: user,
        order: 0
      }

      {:ok, board} = Cartello.create_board(board_creation_params, user)

      card_list_creation_params = %{
        name: "Testing Card List",
        board: board
      }

      {:ok, card_list} = Cartello.create_card_list(card_list_creation_params, user)

      card_creation_params = %{
        name: "Card Test",
        description: "Card bem louco mesmo",
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      checklist_creation_params = %{
        name: "Tarefas",
        card: card
      }

      tag_creation_params = %{
        name: "Johnson",
        color: "#FFF",
        board: board
      }

      {:ok, tag} = Cartello.create_tag(tag_creation_params, user)

      {:ok, checklist} = Cartello.create_checklist(checklist_creation_params, user)

      {:ok, %{user: user, board: board, checklist: checklist, card: card, tag: tag}}
    end

    test "Creating", %{board: board, user: user} do
      tag_creation_params = %{
        name: "Urgente",
        color: "#F00",
        board: board
      }

      {:ok, tag} = Cartello.create_tag(tag_creation_params, user)

      refute tag == nil
      assert tag.name == "Urgente"
      assert tag.color == "#F00"
      assert tag.board_id == board.id
    end

    test "Renaming", %{user: user, tag: tag} do
      tag_update_params = %{
        name: "cleberson"
      }

      {:ok, tag} = Cartello.update_tag(tag, tag_update_params, user)

      assert tag.name == "cleberson"
    end

    test "Color Changing", %{user: user, tag: tag} do
      tag_update_params = %{
        color: "#0F0"
      }

      {:ok, tag} = Cartello.update_tag(tag, tag_update_params, user)

      assert tag.color == "#0F0"
    end

    test "Deleting", %{board: board, user: user, tag: tag} do
      tag_id = tag.id
      {:ok, _tag} = Cartello.delete_tag(tag, user)

      {:ok, board} =
        board.id
        |> Cartello.get_board()

      board = Repo.preload(board, :tags)

      tags = Board.get_tags(board)

      refute Enum.find(tags, fn tag -> tag.id == tag_id end)
    end
  end
end
