defmodule Macchinista.CartelloTest do
  use ExUnit.Case

  alias Macchinista.Accounts
  alias Macchinista.Cartello
  alias Accounts.{User}
  alias Cartello.{Board, Card, CardList, Checklist}
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
        order: 0,
        board: board
      }

      {:ok, card_list} = Cartello.create_card_list(card_list_creation_params, user)

      card_list_creation_params_2 = %{
        name: "Testing Card List 2",
        order: 1,
        board: board
      }

      {:ok, card_list_2} = Cartello.create_card_list(card_list_creation_params_2, user)

      card_creation_params = %{
        name: "Parent Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      {:ok,
       %{user: user, card_list: card_list, card_list_2: card_list_2, board: board, card: card}}
    end

    test "Creating", %{user: user, card_list: card_list} do
      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      card =
        card
        |> Repo.preload(:card_list)
        |> Repo.preload(:parent)

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

    test "Reordering inside a list", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 0,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      card = Repo.preload(card, :parent)

      card_creation_params_2 = %{
        name: "Testing Card 2",
        order: 1,
        card_list: card_list
      }

      {:ok, card_2} = Cartello.create_card(card_creation_params_2, user)

      card_2 = Repo.preload(card_2, :parent)

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

    test "Reordering inside a card", %{card_list: card_list, user: user, card: card} do
      card1_creation_params = %{
        name: "Card A",
        order: 0,
        card_list: card_list,
        parent: card
      }

      card2_creation_params = %{
        name: "Card B",
        order: 1,
        card_list: card_list,
        parent: card
      }

      {:ok, card_1} = Cartello.create_card(card1_creation_params, user)
      {:ok, card_2} = Cartello.create_card(card2_creation_params, user)

      card_1 = Repo.preload(card_1, :parent)
      card_2 = Repo.preload(card_2, :parent)

      assert card_1.parent_id == card.id
      assert card_2.parent_id == card.id

      {:ok, card} = Cartello.get_card(card.id)

      card = Repo.preload(card, :cards)

      assert Enum.find(card.cards, fn c -> c.id == card_1.id end)
      assert Enum.find(card.cards, fn c -> c.id == card_2.id end)

      {:ok, cards} = Cartello.reorder_card(card_2, 0, user)

      card_1 = Enum.find(cards, fn c -> c.id == card_1.id end)
      card_2 = Enum.find(cards, fn c -> c.id == card_2.id end)

      refute card_1 == nil
      refute card_2 == nil

      assert card_1.order == 1
      assert card_2.order == 0
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
        order: 0,
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

    test "Reordering", %{card: card, checklist: checklist, user: user} do
      checklist_2_creation_params = %{
        card: card,
        name: "other checklist",
        order: 1
      }

      {:ok, checklist_2} = Cartello.create_checklist(checklist_2_creation_params, user)

      {:ok, _checklists} = Cartello.reorder_checklist(checklist_2, 0, user)

      {:ok, card} = Cartello.get_card(card.id)

      checklists =
        card
        |> Repo.preload(:checklists)
        |> Card.get_checklists()

      checklist = Enum.find(checklists, fn q -> q.id == checklist.id end)
      checklist_2 = Enum.find(checklists, fn q -> q.id == checklist_2.id end)

      refute checklist == nil
      refute checklist_2 == nil

      assert checklist.order == 1
      assert checklist_2.order == 0
      assert checklist.card_id == card.id
      assert checklist_2.card_id == card.id
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
        order: 0,
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

      quest_creation_params = %{
        name: "Comprar Leite",
        order: 0,
        checklist: checklist
      }

      {:ok, quest} = Cartello.create_quest(quest_creation_params, user)

      {:ok, %{user: user, card: card, checklist: checklist, quest: quest}}
    end

    test "Creating", %{user: user, checklist: checklist} do
      quest_creation_params = %{
        name: "Ir ao mercado",
        order: 1,
        checklist: checklist
      }

      {:ok, quest} = Cartello.create_quest(quest_creation_params, user)

      refute quest == nil
      assert quest.name == "Ir ao mercado"
    end

    test "Activating", %{quest: quest, user: user} do
      quest_update_params = %{
        checked: true
      }

      {:ok, quest} = Cartello.update_quest(quest, quest_update_params, user)

      refute quest == nil

      assert quest.checked == true
    end

    test "Renaming", %{quest: quest, user: user} do
      quest_update_params = %{
        name: "Comprar um elefante"
      }

      {:ok, quest} = Cartello.update_quest(quest, quest_update_params, user)

      refute quest == nil

      assert quest.name == "Comprar um elefante"
    end

    test "Reordering", %{quest: quest, user: user, checklist: checklist} do
      quest_2_creation_params = %{
        checklist: checklist,
        name: "other quest",
        order: 1
      }

      {:ok, quest_2} = Cartello.create_quest(quest_2_creation_params, user)

      {:ok, _quests} = Cartello.reorder_quest(quest_2, 0, user)

      {:ok, checklist} = Cartello.get_checklist(checklist.id)

      quests =
        checklist
        |> Repo.preload(:quests)
        |> Checklist.get_quests()

      quest = Enum.find(quests, fn q -> q.id == quest.id end)
      quest_2 = Enum.find(quests, fn q -> q.id == quest_2.id end)

      refute quest == nil
      refute quest_2 == nil

      assert quest.order == 1
      assert quest_2.order == 0
      assert quest.checklist_id == checklist.id
      assert quest_2.checklist_id == checklist.id
    end

    test "Deleting", %{checklist: checklist, quest: quest, user: user} do
      quest_id = quest.id

      quests =
        checklist
        |> Repo.preload(:quests)
        |> Checklist.get_quests()

      assert Enum.find(quests, fn quest -> quest.id == quest_id end)

      {:ok, _quest} = Cartello.delete_quest(quest, user)

      {:ok, checklist} = Cartello.get_checklist(checklist.id)

      quests =
        checklist
        |> Repo.preload(:quests)
        |> Checklist.get_quests()

      refute Enum.find(quests, fn quest -> quest.id == quest_id end)
    end
  end

  describe "Card List" do
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
        name: "Backlog",
        order: 0,
        board: board
      }

      {:ok, card_list} = Cartello.create_card_list(card_list_creation_params, user)

      {:ok, %{user: user, board: board, card_list: card_list}}
    end

    test "Creating", %{user: user, board: board} do
      card_list_creation_params = %{
        name: "Doing",
        order: 1,
        board: board
      }

      {:ok, card_list} = Cartello.create_card_list(card_list_creation_params, user)

      refute card_list == nil
      assert card_list.name == "Doing"
    end

    test "Renaming", %{user: user, card_list: card_list} do
      card_list_update_params = %{
        name: "Doing"
      }

      {:ok, card_list} = Cartello.update_card_list(card_list, card_list_update_params, user)

      refute card_list == nil
      assert card_list.name == "Doing"
    end

    test "Reordering", %{card_list: card_list, board: board, user: user} do
      card_list_2_creation_params = %{
        board: board,
        name: "other list",
        order: 1
      }

      {:ok, card_list_2} = Cartello.create_card_list(card_list_2_creation_params, user)

      {:ok, _card_lists} = Cartello.reorder_card_list(card_list_2, 0, user)

      {:ok, board} = Cartello.get_board(board.id)

      card_lists =
        board
        |> Repo.preload(:card_lists)
        |> Board.get_card_lists()

      card_list = Enum.find(card_lists, fn c -> c.id == card_list.id end)
      card_list_2 = Enum.find(card_lists, fn c -> c.id == card_list_2.id end)

      refute card_list == nil
      refute card_list_2 == nil

      assert card_list.order == 1
      assert card_list_2.order == 0
      assert card_list.board_id == board.id
      assert card_list_2.board_id == board.id
    end

    test "Shelving", %{card_list: card_list, user: user} do
      card_list_update_params = %{
        shelve: true
      }

      {:ok, card_list} = Cartello.update_card_list(card_list, card_list_update_params, user)

      refute card_list == nil
      assert card_list.shelve == true
    end

    test "Deleting", %{user: user, board: board, card_list: card_list} do
      card_list_id = card_list.id

      card_lists =
        board
        |> Repo.preload(:card_lists)
        |> Board.get_card_lists()

      assert Enum.find(card_lists, fn card_list -> card_list.id == card_list_id end)

      {:ok, _card_list} = Cartello.delete_card_list(card_list, user)

      {:ok, board} = Cartello.get_board(board.id)

      card_lists =
        board
        |> Repo.preload(:card_lists)
        |> Board.get_card_lists()

      refute Enum.find(card_lists, fn card_list -> card_list.id == card_list_id end)
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
        order: 0,
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

      {:ok, board} = Cartello.get_board(board.id)

      board = Repo.preload(board, :tags)

      tags = Board.get_tags(board)

      refute Enum.find(tags, fn tag -> tag.id == tag_id end)
    end
  end
end
