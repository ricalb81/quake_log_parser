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
    return if @players.include?(player) || player == '<world>'

    @players << player
    @kills[player] = 0
  end

  def add_means(means_of_killing)
    @kills_by_means[means_of_killing] = 0 unless @kills_by_means.include?(means_of_killing)
  end

  def add_kill(killer, killed, means)
    @total_kills += 1
    if killer == '<world>'
      @kills[killed] -= 1
    else
      @kills[killer] += 1
    end

    add_means(means)
    @kills_by_means[means] += 1
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
