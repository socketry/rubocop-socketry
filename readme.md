# RuboCop Socketry

Personal RuboCop rules for Socketry projects.

[![Development Status](https://github.com/socketry/rubocop-socketry/workflows/Test/badge.svg)](https://github.com/socketry/rubocop-socketry/actions?workflow=Test)

## Installation

Add this line to your application's Gemfile:

``` ruby
gem "rubocop-socketry"
```

And then execute:

``` bash
bundle install
```

Or install it yourself as:

``` bash
gem install rubocop-socketry
```

## Usage

Add this to your `.rubocop.yml`:

``` yaml
plugins:
  - rubocop-socketry
```

## Available Cops

### Layout/ConsistentBlankLineIndentation

Ensures that blank lines have the same indentation as the previous non-blank line.

``` yaml
Layout/ConsistentBlankLineIndentation:
  Enabled: true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/socketry/rubocop-socketry.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
