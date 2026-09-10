# frozen_string_literal: true

require 'bundler/setup'
require_relative '../lib/alphavantage_as_dataframe'

failures = []
failures << 'version' if AlphavantageAsDataframe::VERSION.to_s.empty?
failures << 'client' unless defined?(AlphavantageAsDataframe::Client)
failures << 'time_series' unless defined?(AlphavantageAsDataframe::TimeSeries)

if failures.empty?
  puts 'test_load: ok'
else
  abort "test_load failed: #{failures.join(', ')}"
end
