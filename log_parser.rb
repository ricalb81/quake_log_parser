# frozen_string_literal: true

class LogParser
  def initialize(file_path)
    @file_path = file_path
    @matches = []
  end

  def parse
    match = nil
    File.foreach(@file_path) do |line|
      if line.include?('InitGame')
        match = new_match
      elsif line.include?('ClientUserinfoChanged')
        add_player_to_match(match, line)
      end
    end
    @matches
  end

  def new_match
    match = Match.new(@matches.size + 1)
    @matches << match
    match
  end

  def add_player_to_match(match, line)
    player = line.split('\\').first.split('n\\').last
    match.add_player(player)
  end
end
