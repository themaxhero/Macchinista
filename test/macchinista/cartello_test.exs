defmodule Macchinista.CartelloTest do
  use ExUnit.Case

  alias Macchinista.Accounts
  alias Macchinista.Cartello

  describe "Card Tests" do
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
        order: 1
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

    test "Create Card", %{user: user, card_list: card_list} do
      card_creation_params = %{
        name: "Testing Card",
        order: 1,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      assert card.name == "Testing Card"
      assert card.order == 1
      assert card.card_list == card_list
      assert card.parent == nil
    end

    test "Move Card", %{card_list: card_list, card_list_2: card_list_2, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 1,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      {:ok, cards} = Cartello.move_card_to_card_list(card, 1, card_list_2, user)

      card = Enum.find(cards, fn c -> c.id == card.id end)

      refute card == nil
      assert card.card_list_id == card_list_2.id
    end

    test "Reorder Card", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 1,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      card_creation_params_2 = %{
        name: "Testing Card",
        order: 2,
        card_list: card_list
      }

      {:ok, card_2} = Cartello.create_card(card_creation_params_2, user)

      {:ok, cards} = Cartello.reorder_card(card_2, 1, user)

      card = Enum.find(cards, fn c -> c.id == card.id end)

      refute card == nil
      assert card.order == 1
      assert card.card_list_id == card_list.id
    end

    test "Rename Card", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 1,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      update_params = %{
        name: "Tested Card"
      }

      {:ok, card} = Cartello.update_card(card, update_params, user)

      assert card.name == "Tested Card"
    end

    test "Edit's Card Description", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 1,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      update_params = %{
        description: "Card's description"
      }

      {:ok, card} = Cartello.update_card(card, update_params, user)

      assert card.description == "Card's description"
    end

    test "Shelve Card", %{card_list: card_list, user: user} do
      card_creation_params = %{
        name: "Testing Card",
        order: 1,
        card_list: card_list
      }

      {:ok, card} = Cartello.create_card(card_creation_params, user)

      {:ok, card} = Cartello.shelve_card(card, user)

      assert card.shelve == true
    end

    test "Asign Tags to Card", %{card_list: card_list, user: user, board: board} do
      tag_creation_params = %{
        name: "Game",
        color: "#990000",
        board: board
      }

      {:ok, _tag} = Cartello.create_tag(tag_creation_params, user)

      card_creation_params = %{
        name: "Testing Card",
        order: 1,
        card_list: card_list
      }

      {:ok, _card} = Cartello.create_card(card_creation_params, user)
    end
  end

  describe "Checklist Tests" do
    test "Create Checklist" do
    end
  end
end
