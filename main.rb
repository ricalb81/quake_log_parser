# frozen_string_literal: true

require './log_parser'

# Create a new LogParser instance to parse the log file
log_parser = LogParser.new

# Parse the log file
log_parser.parse('quake.log')

# Print the report
log_parser.report.each { |match| p match }
