# frozen_string_literal: true

require './log_parser'

# Create a new LogParser instance and parse the log file
log_parser = LogParser.new('quake.log')

# Parse the log file
log_parser.parse

# Print the report
log_parser.report.each { |match| p match }
