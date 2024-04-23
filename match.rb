# frozen_string_literal: true

class Match
  attr_reader :id, :players, :kills, :kills_by_means

  def initialize(id)
    @id = id
    @players = []
    @kills = {}
    @kills_by_means = {}
    @total_kills = 0
  end

  def add_player(player)
    @players << player unless @players.include?(player) || player == '<world>'
  end

  def report
    {
      "game_#{@id}": {
        "total_kills": @total_kills,
        "players": @players,
        "kills": @kills,
        "kills_by_means": @kills_by_means
      }
    }
  end
end
