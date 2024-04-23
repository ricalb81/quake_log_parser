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
end
