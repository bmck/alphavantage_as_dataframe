
# Alpha Vantage Ruby Library

The Alpha Vantage Ruby library provides convenient access to the [Alpha Vantage API](https://www.alphavantage.co/documentation/) from applications written in the Ruby language.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alphavantage_as_dataframe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alphavantage_as_dataframe

## Usage

The library needs to be configured with your account's api key which you can obtain from https://www.alphavantage.co/support/#api-key.
Set the `AlphavantageAsDataframe.configuration.api_key` to its value. If you are using Rails, you can configure this in an initializer.

```ruby
require 'alphavantage_as_dataframe'

AlphavantageAsDataframe.configure do |config|
  config.api_key = 'your-api-key'
end
```

### Accessing a response object
All JSON responses are converted to pseudo-objects that have method-like accessors for hash keys
```ruby
quote = AlphavantageAsDataframe::TimeSeries.new(symbol: 'TSLA').quote
quote.previous_close #=> "719.6900"
quote.volume         #=> "27879033"
```

All hash keys are also normalized to provide clean and consistent access to values since the AlphavantageAsDataframe API returns arbitrarily formatted keys with numbers, spaces, letters and symbols (i.e. "Crypto Rating (FCAS)", "3. fcas rating", "4. Last Refreshed", "Time Series FX (5min)", "1a. open (CNY)")

With this normalization, you can now access via

`intraday.time_series_fx_5min`

instead of

`intraday["Time Series FX (5min)"]`

### Stock Time Series

```ruby
AlphavantageAsDataframe::TimeSeries.search(keywords: 'Tesla')

stock_timeseries = AlphavantageAsDataframe::TimeSeries.new(symbol: 'TSLA')
stock_timeseries.quote
stock_timeseries.monthly
stock_timeseries.monthly(adjusted: true)
stock_timeseries.weekly
stock_timeseries.weekly(adjusted: true)
stock_timeseries.daily(outputsize: 'compact')
stock_timeseries.daily(adjusted: true, outputsize: 'full')
stock_timeseries.intraday(adjusted: true, outputsize: 'compact', interval: '5min')
stock_timeseries.intraday_extended_history(adjusted: true, outputsize: 'compact', interval: '5min', slice: 'year1month1')
```
### Fundamental Data
```ruby
company = AlphavantageAsDataframe::Fundamental.new(symbol: 'TSLA')
company.overview
company.earnings
company.income_statement
company.balance_sheet
company.cash_flow
```
### Forex
```ruby
forex = AlphavantageAsDataframe::Forex.new(from_symbol: 'USD', to_symbol: 'JPY')
forex.exchange_rates
forex.intraday(interval: '5min', outputsize: 'compact')
forex.daily(outputsize: 'compact')
forex.weekly
forex.monthly
```
### Crypto Currencies
```ruby
AlphavantageAsDataframe::Crypto.health_index(symbol: 'BTC')

crypto = AlphavantageAsDataframe::Crypto.new(symbol: 'BTC', market: 'USD')
crypto.intraday(interval: '5min')
crypto.daily
crypto.weekly
crypto.monthly
```

### Technical Indicators
You can access all available indicators by simply using the actual technical indicator name listed on the [Alpha Vantage Documenetation](https://www.alphavantage_as_dataframe.co/documentation/#technical-indicators) as the method name (i.e. `.stoch`, `.rsi`, `.plus_dm`, `.ht_trendline`, etc.).

You can also dig into [alphavantage_as_dataframe/indicator.rb](https://github.com/bmck/alphavantage_as_dataframe/blob/main/lib/alphavantage_as_dataframe/indicator.rb) to view the list of available indicators.

```ruby
indicator = AlphavantageAsDataframe::Indicator.new(symbol: 'TSLA', interval: '5min')
indicator.sma(time_period: 7, series_type: 'close')
indicator.macd(series_type: 'open', fastperiod: 12, slowperiod: 26, signalperiod: 9)

indicator.macdext(
  series_type:,
  fastperiod: 12,
  slowperiod: 26,
  signalperiod: 9,
  fastmatype: 'sma',
  slowmatype: 'sma',
  signalmatype: 'sma'
)
```

Moving average indicator as parameters have been mapped to allow you to simply provide the actual indicator name rather than the number value specified in the Alpha Vantage Documentation. Below is the mapping available that I've used in the above `.macdext` example for the `fastmatype`, `slowmatype` and `signalmatype` parameters

```ruby
MOVING_AVERAGE_TYPES = {
  sma: 0,
  ema: 1,
  wma: 2,
  dema: 3,
  tema: 4,
  trima: 5,
  t3: 6,
  kama: 7,
  mama: 8
}
```

Validations are also implemented to ensure correct values are provided for the various parameters. You can view a list of the validations in [alphavantage_as_dataframe/validations.rb](https://github.com/bmck/alphavantage_as_dataframe/blob/main/lib/alphavantage_as_dataframe/validations.rb)

### Other Functions

To get functions not implemented in the gem you can use the `AlphavantageAsDataframe::Client` class:

If you want to get the news sentiments:

```ruby
AlphavantageAsDataframe::Client.new(function: 'NEWS_SENTIMENT').json
```

If you want to get the list of all listed US stocks and ETFs (Only supports CSV):

```ruby
AlphavantageAsDataframe::Client.new(function: 'LISTING_STATUS').csv
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bmck/alphavantage_as_dataframe. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AlphavantageAsDataframe project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bmck/alphavantage_as_dataframe/blob/master/CODE_OF_CONDUCT.md).
