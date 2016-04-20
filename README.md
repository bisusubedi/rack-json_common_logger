Experimental, Not ready for production usage.
# Rack::JsonCommonLogger

A Rack commonlogger based json logger middleware.
    Its a gem which monkey patches rack commomlogger module to write rack logs in json format

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-json_common_logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-json_common_logger

## Usage
```ruby
    logger = Logger.new(<your-log-device>)
    use Rack::JsonCommonLogger, logger
```
put this code in config.ru file or wherever is your in rack builder setup

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bisusubedi/rack-json_common_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

