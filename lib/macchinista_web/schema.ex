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
      resolve(&BoardResolver.board/3)
    end

    field :card_list, :card_list do
      resolve(&CardListResolver.card_list/3)
    end

    field :card, :card do
      resolve(&CardResolver.card/3)
    end

    field :checklist, :checklist do
      resolve(&ChecklistResolver.checklist/3)
    end

    field :quest, :quest do
      resolve(&QuestResolver.quest/3)
    end

    field :tag, :tag do
      resolve(&TagResolver.tag/3)
    end
  end

  mutation do
    field :register_user, type: :user do
      arg(:input, non_null(:user_input))
      resolve(&UserResolver.register_user/3)
    end

    field :login, type: :session do
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
    end

    field :move_card, :card do
    end

    field :move_card_list, :card_list do
    end

    field :reorder_card_list, :card_list do
    end

    field :reorder_card, :card do
    end

    field :reorder_quest, :quest do
    end

    field :merge_cards, list_of(:card) do
    end

    field :flatten_card, :card do
    end

    field :update_board, type: :board do
      arg(:input, non_null(:board_input))
      resolve(&BoardResolver.update_board/3)
    end

    field :update_card_list, :card_list do
      arg(:input, non_null(:card_list_input))
      resolve(&CardListResolver.update_card_list/3)
    end

    field :update_card, :card do
      arg(:input, non_null(:card_input))
      resolve(&CardResolver.update_card/3)
    end

    field :update_checklist, :checklist do
      arg(:input, non_null(:checklist_input))
      resolve(&ChecklistResolver.update_checklist/3)
    end

    field :update_quest, :quest do
      arg(:input, non_null(:quest_input))
      resolve(&QuestResolver.update_quest/3)
    end

    field :update_tag, :tag do
      arg(:input, non_null(:tag_input))
      resolve(&TagResolver.update_tag/3)
    end
  end

  # subscripton do
  # end
end
