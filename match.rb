# frozen_string_literal: true

# The Match class represents a match in a game.
# It keeps track of players, kills, and the means of kills.
# It also provides a report of the match.
class Match
  attr_reader :id, :players, :kills, :kills_by_means

  # The Match constructor initializes a new match with a given id.
  # It also initializes players, kills, and kills_by_means as empty hashes,
  # and total_kills as 0.
  #
  # @param id [Integer] The id of the match.
  def initialize(id)
    @id = id
    @players = []
    @kills = {}
    @kills_by_means = {}
    @total_kills = 0
  end

  # The add_player method adds a new player to the match.
  # It does not add the player if they already exist or if the player is '<world>'.
  #
  # @param player [String] The name of the player.
  def add_player(player)
    return if @players.include?(player) || player == '<world>'

    @players << player
    @kills[player] = 0
  end

  # The add_means method adds a new means of killing to the match.
  # It does not add the means if it already exists.
  #
  # @param means_of_killing [String] The means of killing.
  def add_means(means_of_killing)
    @kills_by_means[means_of_killing] = 0 unless @kills_by_means.include?(means_of_killing)
  end

  # The add_kill method adds a new kill to the match.
  # It increases the total kills and the kills of the killer.
  # If the killer is '<world>', it decreases the kills of the killed.
  # It also increases the kills by the means of killing.
  #
  # @param killer [String] The name of the killer.
  # @param killed [String] The name of the killed.
  # @param means [String] The means of killing.
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

  # The report method returns a report of the match.
  # The report includes the total kills, the players, the kills, and the kills by means.
  #
  # @return [Hash] The report of the match.
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
