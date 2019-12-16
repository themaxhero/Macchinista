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
  end

  # subscripton do
  # end
end
