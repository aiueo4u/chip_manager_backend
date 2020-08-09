class NpcPlayer
  attr_reader :manager, :game_hand, :table_player

  PLAYER_ACTION_BET_CHIPS = 'PLAYER_ACTION_BET_CHIPS'
  PLAYER_ACTION_CALL = 'PLAYER_ACTION_CALL'
  PLAYER_ACTION_CHECK = 'PLAYER_ACTION_CHECK'
  PLAYER_ACTION_FOLD = 'PLAYER_ACTION_FOLD'
  PLAYER_ACTION_SHOW_HAND = 'PLAYER_ACTION_SHOW_HAND'
  PLAYER_ACTION_MUCK_HAND = 'PLAYER_ACTION_MUCK_HAND'

  def initialize(table_id, player_id)
    @manager = GameManager.new(table_id)
    @game_hand = @manager.game_hand
    @table_player = @game_hand.table_player_by_player_id(player_id)
  end

  def output
    type = PLAYER_ACTION_CHECK
    amount = nil

    if manager.current_state == 'result'
      type = lot(80) ? PLAYER_ACTION_SHOW_HAND : PLAYER_ACTION_MUCK_HAND
    else
      # TODO
      current_round = manager.current_state
      current_round_actions = game_hand.all_actions.group_by(&:state)[current_round] || []

      # 本フェーズでの最高ベット額を取得
      amount_to_call = calc_call

      # 誰もベットしていない場合
      if current_round_actions.none? { |action| action.bet? || action.blind? }
        # オリジナルがいないorオリジナルならば、50%の確率でベット
        if (!last_aggressive_player_id || last_aggressor?) && lot(50)
          type = PLAYER_ACTION_BET_CHIPS
          amount = calc_bet(amount_to_call)
        end
      # 誰かがベットしていたら（ブラインド含む）
      else
        weights = [
          [PLAYER_ACTION_BET_CHIPS, 20],
          [PLAYER_ACTION_CALL, 60],
          [PLAYER_ACTION_FOLD, 40],
        ]
        type = lot_by_weights(weights)
        case type
        when PLAYER_ACTION_CALL
          amount = amount_to_call
        when PLAYER_ACTION_BET_CHIPS
          amount = cals_raise(amount_to_call)
        end
      end
    end

    [type, amount]
  end

  private

  def current_stack
    current_game_hand_player.stack
  end

  def current_game_hand_player
    game_hand.game_hand_player_by_id(table_player.player_id)
  end

  def calc_call
    game_hand.amount_to_call_by_player_id(table_player.player_id)
  end

  def cals_raise(amount_to_call)
    [amount_to_call * 3, current_stack].min
  end

  def calc_bet(amount_to_call)
    amount = amount_to_call + (amount_to_call + game_hand.pot_amount) / 2
    if amount % 10 != 0
      amount = (amount / 10) * 10
    end

    if amount > 1000
      amount = (amount / 100) * 100
    end

    [amount, current_stack].min
  end

  def lot_by_weights(weights)
    total = weights.map { |w| w[1] }.sum
    weights.each do |weight|
      if rand(total) < weight[1]
        return weight[0]
      else
        total -= weight[1]
      end
    end
    return weights[0][0]
  end

  def lot(prob)
    rand(100) < prob
  end

  def last_aggressor?
    last_aggressive_player_id == table_player.player_id
  end

  def last_aggressive_player_id
    unless @last_aggressive_player_id
      last_action_round = game_hand.state
      last_round_actions = game_hand.all_actions.group_by(&:state)[last_action_round]
      @last_aggressive_player_id = last_round_actions.select(&:bet?).sort_by(&:order_id).last&.player_id
    end
    @last_aggressive_player_id
  end
end
