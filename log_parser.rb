# frozen_string_literal: true

# The LogParser class is used to parse a log file and create matches.
# It keeps track of the matches and provides a report of all matches.
class LogParser
  require './match'

  # The LogParser constructor initializes a new LogParser with a given file path.
  # It also initializes matches as an empty array.
  #
  # @param file_path [String] The path to the log file.
  def initialize(file_path)
    @file_path = file_path
    @matches = []
  end

  # The parse method parses the log file and creates matches.
  # It creates a new match when it finds 'InitGame',
  # adds a player to the match when it finds 'ClientUserinfoChanged',
  # and adds a kill to the match when it finds 'Kill:'.
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

  # The new_match method creates a new match and adds it to the matches.
  #
  # @return [Match] The new match.
  def new_match
    match = Match.new(@matches.size + 1)
    @matches << match
    match
  end

  # The add_player_to_match method adds a player to a given match.
  # It finds the player's name in a given line and adds the player to the match.
  #
  # @param match [Match] The match to add the player to.
  # @param line [String] The line to find the player's name in.
  def add_player_to_match(match, line)
    line = line.split('ClientUserinfoChanged').last
    player = line.split('\\')[1].strip
    match.add_player(player)
  end

  # The add_kill_to_match method adds a kill to a given match.
  # It finds the killer's name, the killed's name, and the means in a given line,
  # and adds the kill to the match.
  #
  # @param match [Match] The match to add the kill to.
  # @param line [String] The line to find the killer's name, the killed's name, and the means in.
  def add_kill_to_match(match, line)
    line = line.split('Kill:').last
    killer, line = line.split(':')[1].split('killed').map(&:strip)
    killed, means = line.split('by').map(&:strip)
    match.add_kill(killer, killed, means)
  end

  # The report method returns a report of all matches.
  #
  # @return [Array<Hash>] The report of all matches.
  def report
    @matches.map(&:report)
  end
end
