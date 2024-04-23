# frozen_string_literal: true

# Class used to parse the log file and create the matches
class LogParser
  require './match'

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
      elsif line.include?('Kill:')
        add_kill_to_match(match, line)
      end
    end
  end

  def new_match
    match = Match.new(@matches.size + 1)
    @matches << match
    match
  end

  def add_player_to_match(match, line)
    line = line.split('ClientUserinfoChanged').last
    player = line.split('\\')[1].strip
    match.add_player(player)
  end

  def add_kill_to_match(match, line)
    line = line.split('Kill:').last
    killer, line = line.split(':')[1].split('killed').map(&:strip)
    killed, means = line.split('by').map(&:strip)
    match.add_kill(killer, killed, means)
  end
end
