class CreateGameHandCommand
  include Command

  attr_reader :table, :current_player, :manager

  validate :validate_table

  def initialize(table_id:, current_player_id:)
    @table = Table.find(table_id)
    @current_player = Player.find(current_player_id)
  end

  def run
    table.with_lock do
      raise ActiveRecord::Rollback if invalid?

      exclude_non_active_players

      GameHand.create_new_game(table)

      @manager = GameManager.new(table.id, just_created: true)
    end

    if success?
      @manager.broadcast

      # 最初のプレイヤーのターン開始
      table_player = @manager.game_hand.table_player_by_seat_no(@manager.game_hand.current_seat_no)
      if table_player.auto_play?
        NpcPlayerJob.perform_later(table.id, table_player.player_id)
      end
      TimeKeeperJob.perform_later(table.id, table_player.player_id, @manager.game_hand.last_action.order_id)
    end
  end

  private

  def validate_table
    manager = GameManager.new(table.id)

    if table.table_players.count(&:can_play_next_game?) < 2
      errors.add(:table, :invalid)
      return
    end

    # 前回のゲームが終了状態になっているかチェック
    errors.add(:table, :invalid) if manager.game_hand && manager.current_state != 'finished'
  end

  def exclude_non_active_players
    # スタックが無いプレイヤーはゲーム開始時に除外しておく
    # タイムアウトを重ねたプレイヤーも除外
    table.table_players.each do |table_player|
      if !table_player.can_play_next_game?
        table_player.destroy!
      end
    end
  end
end
