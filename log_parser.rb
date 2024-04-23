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
      end
    end
    @matches
  end

  def new_match
    match = Match.new(@matches.size + 1)
    @matches << match
    match
  end
end
