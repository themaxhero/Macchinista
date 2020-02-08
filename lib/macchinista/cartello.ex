defmodule Macchinista.Cartello do
  alias Macchinista.Repo
  alias Macchinista.Cartello.{Board, CardList, Card, Checklist, Tag, Quest}
  alias Card.Query, as: CardQuery

  @spec create_board(Board.creation_params(), User.t()) ::
          {:ok, Board.t()}
          | {:error, atom() | String.t()}
  def create_board(attrs, _user) do
    Repo.transaction(fn ->
      board =
        attrs
        |> Board.create_changeset()
        |> Repo.insert()

      case board do
        {:ok, board} ->
          # create_log(board, :board, :insert, :success, user)
          board

        {:error, :internal} ->
          # create_log(board, :board, :insert, :failed, user)
          Repo.rollback(:internal)
      end
    end)
  end

  @spec get_board(Board.id()) ::
          {:ok, Board.t()}
          | {:error, atom() | String.t()}
  def get_board(id) when is_binary(id) do
    case Repo.get(Board, id) do
      nil -> {:error, :not_found}
      %Board{} = board -> {:ok, board}
    end
  end

  @spec update_board(Board.t(), Board.update_params(), User.t()) ::
          {:ok, Board.t()}
          | {:error, atom() | String.t()}
  def update_board(%Board{} = board, attrs, _user) do
    Repo.transaction(fn ->
      board =
        board
        |> Board.update_changeset(attrs)
        |> Repo.update()

      case board do
        {:ok, board} ->
          # create_log(board, :board, :update, :success, user)
          board

        {:error, _changeset} ->
          # create_log(board, :board, :update, :failed, user)
          Repo.rollback(:internal)
      end
    end)
  end

  @spec shelve_board(Board.t(), User.t()) ::
          {:ok, Board.t()}
          | {:error, atom() | String.t()}
  def shelve_board(%Board{} = board, _user) do
    Repo.transaction(fn ->
      board =
        board
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_change(:shelve, true)
        |> Repo.update()

      case board do
        {:ok, board} ->
          # create_log(board, :board, :update, :success, user)
          board

        {:error, _changeset} ->
          # create_log(board, :board, :update, :failed, user)
          Repo.rollback(:internal)
      end
    end)
  end

  @spec delete_board(Board.t(), User.t()) ::
          {:ok, Board.t()}
          | {:error, atom() | String.t()}
  def delete_board(board, _user) do
    Repo.transaction(fn ->
      case Repo.delete(board) do
        {:ok, board} ->
          # create_log(board, :board, :delete, :success, user)
          board

        {:error, _changeset} ->
          # create_log(board, :board, :delete, :failed, user)
          Repo.rollback(:internal)
      end
    end)
  end

  @spec create_card_list(CardList.creation_paramsreation_params(), User.t()) ::
          {:ok, CardList.t()}
          | {:error, atom() | String.t()}
  def create_card_list(attrs, _user) do
    Repo.transaction(fn ->
      card_list =
        attrs
        |> CardList.create_changeset()
        |> Repo.insert()

      case card_list do
        {:ok, card_list} ->
          card_list

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec get_card_list(CardList.id()) ::
          {:ok, CardList.t()}
          | {:error, atom() | String.t()}
  def get_card_list(id) when is_binary(id) do
    case Repo.get(CardList, id) do
      nil ->
        {:error, :not_found}

      %CardList{} = card_list ->
        {:ok, Repo.preload(card_list, :cards)}
    end
  end

  @spec update_card_list(CardList.t(), CardList.update_params(), User.t()) ::
          {:ok, CardList.t()}
          | {:error, atom() | String.t()}
  def update_card_list(card_list, attrs, _user) do
    Repo.transaction(fn ->
      card_list =
        card_list
        |> CardList.update_changeset(attrs)
        |> Repo.update()

      case card_list do
        {:ok, card_list} ->
          card_list

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec delete_card_list(CardList.t(), User.t()) ::
          {:ok, CardList.t()}
          | {:error, atom() | String.t()}
  def delete_card_list(card_list, _user) do
    Repo.transaction(fn ->
      card_list = Repo.delete(card_list)

      case card_list do
        {:ok, card} ->
          card

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec create_card(Card.creation_paramsreation_params(), User.t()) ::
          {:ok, Card.t()}
          | {:error, atom() | String.t()}
  def create_card(attrs, _user) do
    Repo.transaction(fn ->
      card =
        attrs
        |> Card.create_changeset()
        |> Repo.insert()

      case card do
        {:ok, card} ->
          card

        {:error, changeset} ->
          IO.inspect(changeset)
          Repo.rollback(:internal)
      end
    end)
  end

  @spec get_card(Card.id()) ::
          {:ok, Card.t()}
          | {:error, atom() | String.t()}
  def get_card(id) when is_binary(id) do
    case Repo.get(Card, id) do
      nil -> {:error, :not_found}
      %Card{} = card -> {:ok, card}
    end
  end

  @spec update_card(Card.t(), Card.update_params(), User.t()) ::
          {:ok, Card.t()}
          | {:error, atom() | String.t()}
  def update_card(card, attrs, _user) do
    Repo.transaction(fn ->
      card =
        card
        |> Card.update_changeset(attrs)
        |> Repo.update()

      case card do
        {:ok, card} ->
          card

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec delete_card(Card.t(), User.t()) ::
          {:ok, Card.t()}
          | {:error, atom() | String.t()}
  def delete_card(card, _user) do
    Repo.transaction(fn ->
      case Repo.delete(card) do
        {:ok, card} ->
          card

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec create_checklist(Checklist.creation_params(), User.t()) ::
          {:ok, Checklist.t()}
          | {:error, atom() | String.t()}
  def create_checklist(attrs, _user) do
    Repo.transaction(fn ->
      checklist =
        attrs
        |> Checklist.create_changeset()
        |> Repo.insert()

      case checklist do
        {:ok, checklist} ->
          checklist

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec get_checklist(Checklist.id()) ::
          {:ok, Checklist.t()}
          | {:error, atom() | String.t()}
  def get_checklist(id) when is_binary(id) do
    case Repo.get(Checklist, id) do
      nil -> {:error, :not_found}
      %Checklist{} = checklist -> {:ok, checklist}
    end
  end

  @spec update_checklist(Checklist.t(), Checklist.update_params(), User.t()) ::
          {:ok, Checklist.t()}
          | {:error, atom() | String.t()}
  def update_checklist(checklist, attrs, _user) do
    Repo.transaction(fn ->
      checklist =
        checklist
        |> Checklist.update_changeset(attrs)
        |> Repo.update()

      case checklist do
        {:ok, checklist} ->
          checklist

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec delete_checklist(Checklist.t(), User.t()) ::
          {:ok, Checklist.t()}
          | {:error, atom() | String.t()}
  def delete_checklist(checklist, _user) do
    Repo.transaction(fn ->
      case Repo.delete(checklist) do
        {:ok, checklist} ->
          checklist

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec create_tag(Tag.creation_params(), User.t()) ::
          {:ok, Tag.t()}
          | {:error, atom() | String.t()}
  def create_tag(attrs, _user) do
    Repo.transaction(fn ->
      tag =
        attrs
        |> Tag.create_changeset()
        |> Repo.insert()

      case tag do
        {:ok, tag} ->
          tag

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec get_tag(Tag.id()) ::
          {:ok, Tag.t()}
          | {:error, atom() | String.t()}
  def get_tag(id) when is_binary(id) do
    case Repo.get(Tag, id) do
      nil -> {:error, :not_found}
      %Tag{} = tag -> {:ok, tag}
    end
  end

  @spec update_tag(Tag.t(), Tag.update_params(), User.t()) ::
          {:ok, Tag.t()}
          | {:error, atom() | String.t()}
  def update_tag(tag, attrs, _user) do
    Repo.transaction(fn ->
      tag =
        tag
        |> Tag.update_changeset(attrs)
        |> Repo.update()

      case tag do
        {:ok, tag} ->
          tag

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec delete_tag(Tag.t(), User.t()) ::
          {:ok, Tag.t()}
          | {:error, atom() | String.t()}
  def delete_tag(tag, _user) do
    Repo.transaction(fn ->
      case Repo.delete(tag) do
        {:ok, tag} ->
          tag

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec create_quest(Quest.creation_paramsreation_params(), User.t()) ::
          {:ok, Quest.t()}
          | {:error, atom() | String.t()}
  def create_quest(attrs, _user) do
    Repo.transaction(fn ->
      quest =
        attrs
        |> Quest.create_changeset()
        |> Repo.insert()

      case quest do
        {:ok, quest} ->
          quest

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec get_quest(Quest.id()) ::
          {:ok, Quest.t()}
          | {:error, atom() | String.t()}
  def get_quest(id) when is_binary(id) do
    case Repo.get(Quest, id) do
      nil -> {:error, :not_found}
      %Quest{} = quest -> {:ok, quest}
    end
  end

  @spec update_quest(Quest.t(), Quest.update_params(), User.t()) ::
          {:ok, Quest.t()}
          | {:error, atom() | String.t()}
  def update_quest(quest, attrs, _user) do
    Repo.transaction(fn ->
      quest =
        quest
        |> Quest.update_changeset(attrs)
        |> Repo.update()

      case quest do
        {:ok, quest} ->
          quest

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec delete_quest(Quest.t(), User.t()) ::
          {:ok, Quest.t()}
          | {:error, atom() | String.t()}
  def delete_quest(quest, _user) do
    Repo.transaction(fn ->
      case Repo.delete(quest) do
        {:ok, quest} ->
          quest

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec new_position(integer(), integer()) :: integer()
  defp new_position(pos, last) when pos > last + 1,
    do: last + 1

  defp new_position(pos, _) when pos < 0,
    do: 0

  defp new_position(pos, _),
    do: pos

  @spec move_card_to_card_list(Card.t(), Card.order(), CardList.t(), User.t()) ::
          {:ok, [Card.t()]}
          | {:error, atom() | String.t()}
  def move_card_to_card_list(%Card{card_list: destination}, _order, destination, _user),
    do: {:error, :invalid_arguments}

  def move_card_to_card_list(
        %Card{card_list: from, order: from_order} = card,
        to_order,
        destination,
        _user
      ) do
    Repo.transaction(fn ->
      get_order = fn card ->
        if card != nil,
          do: Card.get_order(card),
          else: 0
      end

      last_order =
        destination
        |> CardList.get_last_card()
        |> get_order.()

      order = new_position(to_order, last_order)

      card =
        card
        |> Card.set_order(order)
        |> Card.set_card_list(destination)

      from_cards =
        from
        |> CardQuery.by_card_list_and_order_gt(from_order)
        |> Repo.all()
        |> Enum.map(&Card.set_order(&1, &1.order + 1))

      to_cards =
        destination
        |> CardQuery.by_card_list_and_order_gt(to_order)
        |> Repo.all()
        |> Enum.map(&Card.set_order(&1, &1.order + 1))

      cards =
        from_cards
        |> Kernel.++(to_cards)
        |> Kernel.++([card])
        |> Enum.map(&Repo.update/1)

      case Enum.find(cards, fn {status, _} -> status == :error end) do
        nil ->
          Enum.map(cards, fn {_, card} -> card end)

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec reorder_card(Card.t(), Card.order(), User.t()) ::
          {:ok, [Card.t()]}
          | {:error, atom() | String.t()}
  def reorder_card(%Card{id: id, card_list: card_list, parent: nil} = card, order, _user) do
    Repo.transaction(fn ->
      get_order = fn card ->
        if card != nil,
          do: Card.get_order(card),
          else: 0
      end

      {:ok, card_list} = get_card_list(card_list.id)

      last_order =
        card_list
        |> CardList.get_last_card()
        |> get_order.()

      order = new_position(order, last_order)

      {:ok, card} = Repo.delete(card)

      card = Card.update_changeset(card, %{order: order})

      update_went_ok? = fn {status, card} ->
        case status do
          :ok -> card
          :error -> Repo.rollback(:internal)
        end
      end

      {:ok, cards} =
        Repo.transaction(fn ->
          card_list
          |> CardList.get_cards()
          |> Enum.filter(fn card -> card.id != id && card.order >= order end)
          |> Enum.map(fn card ->
            card
            |> Card.update_changeset(%{order: card.order + 1})
            |> Repo.update()
            |> update_went_ok?.()
          end)
        end)

      case Repo.insert(card) do
        {:ok, card} ->
          [card | cards]

        _ ->
          Repo.rollback(:internal)
      end
    end)
  end

  def reorder_card(%Card{id: id, parent: parent, order: _from} = card, order, user) do
    Repo.transaction(fn ->
      {:ok, parent} = get_card(parent.id)

      parent = Repo.preload(parent, :cards)

      last_order =
        parent
        |> Card.get_last_nested_card()
        |> Card.get_order()

      card =
        card
        |> Repo.preload(:cards)
        |> Repo.preload(:checklists)
        |> Repo.preload(:tags)

      {:ok, card} = delete_card(card, user)

      order = new_position(order, last_order)

      siblings =
        parent
        |> Card.get_cards()
        |> Enum.filter(fn card -> card.order >= order && card.id != id end)
        |> Enum.map(fn card ->
          card
          |> Card.set_order(card.order + 1)
          |> Repo.update()
        end)

      card_and_status =
        card
        |> Card.update_changeset(%{order: order})
        |> Repo.insert()

      cards = [card_and_status | siblings]

      case Enum.find(cards, fn {status, _} -> status == :error end) do
        nil ->
          Enum.map(cards, fn {_, card} -> card end)

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec reorder_checklist(Checklist.t(), Checklist.order(), User.t()) ::
          {:ok, [Checklist.t()]}
          | {:error, atom() | String.t()}
  def reorder_checklist(%Checklist{order: _from, card: card} = checklist, order, _user) do
    Repo.transaction(fn ->
      get_order = fn checklist ->
        if checklist != nil,
          do: Checklist.get_order(checklist),
          else: 0
      end

      last_order =
        card
        |> Card.get_last_checklist()
        |> get_order.()

      order = new_position(order, last_order)

      siblings =
        card
        |> Card.get_checklists()
        |> Enum.filter(fn checklist -> checklist.order > order end)
        |> Enum.map(&Checklist.set_order(&1, &1.order + 1))

      checklist = Checklist.set_order(checklist, order)

      checklists =
        [checklist | siblings]
        |> Enum.reverse()
        |> Enum.map(&Repo.update/1)

      case Enum.find(checklists, fn {status, _} -> status == :error end) do
        nil ->
          Enum.map(checklists, fn {_, checklist} -> checklist end)

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec reorder_quest(Quest.t(), Quest.order(), User.t()) ::
          {:ok, [Quest.t()]}
          | {:error, atom() | String.t()}
  def reorder_quest(%Quest{checklist: checklist} = quest, order, _user) do
    Repo.transaction(fn ->
      last_order =
        checklist
        |> Checklist.get_last_quest()
        |> Quest.get_order()

      order = new_position(order, last_order)

      siblings =
        checklist
        |> Checklist.get_quests()
        |> Enum.filter(fn quest -> quest.order > order end)
        |> Enum.map(&Quest.set_order(&1, &1.order + 1))

      quest = Quest.set_order(quest, order)

      quests =
        [quest | siblings]
        |> Enum.reverse()
        |> Enum.map(&Repo.update/1)

      case Enum.find(quests, fn {status, _} -> status == :error end) do
        nil ->
          Enum.map(quests, fn {_, quest} -> quest end)

        {:error, _changeset} ->
          Repo.rollback(:internal)
          {:error, :internal}
      end
    end)
  end

  @spec merge_cards([Card.t()], User.t()) ::
          {:ok, [Card.t()]}
          | {:error, atom() | String.t()}
  def merge_cards(cards, user) do
    Repo.transaction(fn ->
      list =
        cards
        |> Enum.map(&Card.get_card_list/1)
        |> Enum.uniq()

      order =
        cards
        |> Enum.sort(&(&1.order < &2.order))
        |> List.first()
        |> Card.get_order()

      list_count = Enum.count(list)

      case list_count do
        1 ->
          [card_list] = list
          {:ok, parent} = create_card(%{card_list: card_list, order: order}, user)

          {updated_cards, _} =
            cards
            |> Enum.reduce({[], 0}, fn elem, {acc, order} ->
              card =
                elem
                |> Card.set_parent(parent.id)
                |> Card.set_order(order)
                |> Repo.update()

              {[card | acc], order + 1}
            end)

          case Enum.find(updated_cards, fn {status, _} -> status == :error end) do
            nil ->
              Enum.map(updated_cards, fn {_, card} -> card end)

            {:error, _changeset} ->
              Repo.rollback(:internal)
          end

        _ ->
          Repo.rollback(:list_should_be_same)
      end
    end)
  end

  @spec flatten_card(Card.t(), User.t()) ::
          {:ok, [Card.t()]}
          | {:error, atom() | String.t()}
  def flatten_card(
        %Card{id: id, cards: cards, card_list: card_list, order: order, parent: nil} = card,
        _user
      ) do
    Repo.transaction(fn ->
      count = Enum.count(cards)

      next_cards =
        card_list
        |> CardList.get_cards()
        |> Enum.filter(fn card -> card.order > order end)
        |> Enum.map(&Card.set_order(&1, &1.order + count))
        |> Enum.map(&Repo.update/1)

      {cards, _} =
        cards
        |> Enum.reduce({[], order}, fn elem, {acc, count} ->
          card =
            elem
            |> Card.set_order(count)
            |> Card.set_parent(nil)
            |> Repo.update()

          {[card | acc], count + 1}
        end)

      cards = [Repo.delete(card) | next_cards ++ cards]

      return = fn ->
        cards
        |> Enum.map(fn {_, card} -> card end)
        |> Enum.filter(fn card -> card.id != id end)
      end

      case Enum.find(cards, fn {status, _} -> status == :error end) do
        nil ->
          return.()

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  def flatten_card(
        %Card{id: id, cards: cards, order: order, parent: parent_id} = card,
        _user
      ) do
    Repo.transaction(fn ->
      count = Enum.count(cards)

      next_cards =
        Card
        |> Repo.get(parent_id)
        |> Card.get_cards()
        |> Enum.filter(fn card -> card.order > order end)
        |> Enum.map(&Card.set_order(&1, &1.order + count))
        |> Enum.map(&Repo.update/1)

      {cards, _} =
        cards
        |> Enum.reduce({[], order}, fn elem, {acc, count} ->
          card =
            elem
            |> Card.set_order(count)
            |> Card.set_parent(parent_id)
            |> Repo.update()

          {[card | acc], count + 1}
        end)

      cards = [Repo.delete(card) | next_cards ++ cards]

      return = fn ->
        cards
        |> Enum.map(fn {_, card} -> card end)
        |> Enum.filter(fn card -> card.id != id end)
      end

      case Enum.find(cards, fn {status, _} -> status == :error end) do
        nil ->
          return.()

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end

  @spec shelve_card(Card.t(), User.t()) ::
          {:ok, Card.t()}
          | {:error, atom() | String.t()}
  def shelve_card(card, _user) do
    Repo.transaction(fn ->
      result =
        card
        |> Card.set_shelve(true)
        |> Repo.update()

      case result do
        {:ok, card} ->
          card

        {:error, _changeset} ->
          Repo.rollback(:internal)
      end
    end)
  end
end
