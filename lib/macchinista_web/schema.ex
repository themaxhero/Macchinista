defmodule MacchinistaWeb.Schema do
  use Absinthe.Schema
  alias MacchinistaWeb.Resolvers.User, as: UserResolver
  alias MacchinistaWeb.Resolvers.Session, as: SessionResolver
  alias MacchinistaWeb.Resolvers.Board, as: BoardResolver
  alias MacchinistaWeb.Resolvers.CardList, as: CardListResolver
  alias MacchinistaWeb.Resolvers.Card, as: CardResolver
  alias MacchinistaWeb.Resolvers.Checklist, as: ChecklistResolver
  alias MacchinistaWeb.Resolvers.Quest, as: QuestResolver
  alias MacchinistaWeb.Resolvers.Tag, as: TagResolver

  import_types(MacchinistaWeb.Schema.Types)

  query do
    field :users, list_of(:user) do
      resolve(&UserResolver.users/3)
    end

    field :boards, list_of(:board) do
      resolve(&BoardResolver.boards/3)
    end

    field :card_lists, list_of(:card_list) do
      resolve(&CardListResolver.card_list/3)
    end

    field :cards, list_of(:card) do
      resolve(&CardResolver.cards/3)
    end

    field :checklists, list_of(:checklist) do
      resolve(&ChecklistResolver.checklists/3)
    end

    field :quests, list_of(:quest) do
      resolve(&QuestResolver.quests/3)
    end

    field :tags, list_of(:tag) do
      resolve(&TagResolver.tags/3)
    end

    field :board, :board do
      arg(:id, non_null(:id))
      resolve(&BoardResolver.board/3)
    end

    field :card_list, :card_list do
      resolve(&CardListResolver.card_list/3)
    end

    field :card, :card do
      arg(:id, non_null(:id))
      resolve(&CardResolver.card/3)
    end

    field :checklist, :checklist do
      arg(:id, non_null(:id))
      resolve(&ChecklistResolver.checklist/3)
    end

    field :quest, :quest do
      arg(:id, non_null(:id))
      resolve(&QuestResolver.quest/3)
    end

    field :tag, :tag do
      arg(:id, non_null(:id))
      resolve(&TagResolver.tag/3)
    end
  end

  mutation do
    field :register_user, type: :user do
      arg(:input, non_null(:user_input))
      resolve(&UserResolver.register_user/3)
    end

    field :login, type: :string do
      arg(:input, non_null(:login_input))
      resolve(&SessionResolver.login/3)
    end

    field :create_board, type: :board do
      arg(:input, non_null(:board_input))
      resolve(&BoardResolver.create_board/3)
    end

    field :create_card_list, :card_list do
      arg(:input, non_null(:card_list_input))
      resolve(&CardListResolver.create_card_list/3)
    end

    field :create_card, :card do
      arg(:input, non_null(:card_input))
      resolve(&CardResolver.create_card/3)
    end

    field :create_checklist, :checklist do
      arg(:input, non_null(:checklist_input))
      resolve(&ChecklistResolver.create_checklist/3)
    end

    field :create_quest, :quest do
      arg(:input, non_null(:quest_input))
      resolve(&QuestResolver.create_quest/3)
    end

    field :create_tag, :tag do
      arg(:input, non_null(:tag_input))
      resolve(&TagResolver.create_tag/3)
    end

    field :shelve_card, :card do
      arg(:input, non_null(:shelve_card_input))
      resolve(&CardResolver.shelve_card/3)
    end

    field :move_card, :card do
      arg(:input, non_null(:move_card_input))
      resolve(&CardResolver.move_card/3)
    end

    field :reorder_card, :card do
      arg(:input, non_null(:reorder_card_input))
      resolve(&CardResolver.reorder_card/3)
    end

    field :merge_cards, list_of(:card) do
      arg(:input, non_null(:merge_cards_input))
      resolve(&CardResolver.merge_cards/3)
    end

    field :flatten_card, :card do
      arg(:input, non_null(:flatten_card_input))
      resolve(&CardResolver.flatten_card/3)
    end

    # field :move_card_list, :card_list do
    #   arg(:input, non_null(:move_card_list_input))
    #   resolve(&CardListResolver.move_card_list/3)
    # end

    # field :reorder_card_list, :card_list do
    #   arg(:input, non_null(:reorder_card_list_input))
    #   resolve(&CardListResolver.reorder_card_list/3)
    # end

    field :reorder_quest, :quest do
      arg(:input, non_null(:reorder_quest_input))
      resolve(&QuestResolver.reorder_quest/3)
    end

    field :reorder_checklist, :checklist do
      arg(:input, non_null(:reorder_checklist_input))
      resolve(&ChecklistResolver.reorder_checklist/3)
    end

    field :update_board, type: :board do
      arg(:input, non_null(:board_update_input))
      resolve(&BoardResolver.update_board/3)
    end

    field :update_card_list, :card_list do
      arg(:input, non_null(:card_list_update_input))
      resolve(&CardListResolver.update_card_list/3)
    end

    field :update_card, :card do
      arg(:input, non_null(:card_update_input))
      resolve(&CardResolver.update_card/3)
    end

    field :update_checklist, :checklist do
      arg(:input, non_null(:checklist_update_input))
      resolve(&ChecklistResolver.update_checklist/3)
    end

    field :update_quest, :quest do
      arg(:input, non_null(:quest_update_input))
      resolve(&QuestResolver.update_quest/3)
    end

    field :update_tag, :tag do
      arg(:input, non_null(:tag_update_input))
      resolve(&TagResolver.update_tag/3)
    end

    field :delete_board, type: :board do
      arg(:input, non_null(:board_delete_input))
      resolve(&BoardResolver.delete_board/3)
    end

    field :delete_card_list, :card_list do
      arg(:input, non_null(:card_list_delete_input))
      resolve(&CardListResolver.delete_card_list/3)
    end

    field :delete_card, :card do
      arg(:input, non_null(:card_delete_input))
      resolve(&CardResolver.delete_card/3)
    end

    field :delete_checklist, :checklist do
      arg(:input, non_null(:checklist_delete_input))
      resolve(&ChecklistResolver.delete_checklist/3)
    end

    field :delete_quest, :quest do
      arg(:input, non_null(:quest_delete_input))
      resolve(&QuestResolver.delete_quest/3)
    end

    field :delete_tag, :tag do
      arg(:input, non_null(:tag_delete_input))
      resolve(&TagResolver.delete_tag/3)
    end
  end

  # subscripton do
  # end
end
