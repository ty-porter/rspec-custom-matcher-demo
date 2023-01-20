# rspec-custom-matcher-demo

_This repo accompanies a post on my blog that you can find [here](https://blog.ty-porter.dev/development/testing/2023/01/20/custom-rspec-matchers.html)._

RSpec custom matchers give you lots of power to define how you test your code. This repo sets up some example classes to run tests against.

## Overview

`lib/example.rb` defines the two classes under test:

* An `ExampleSender` class that can package up an example message in hash format and then merge volatile data into it, such as a generated UUID, timestamp, or sequential ID. This message is then serialized to JSON and passed to the receiver below.
* An `ExampleReceiver` class that does nothing but log the message to `STDOUT`.

`spec/example_spec.rb` contains the example test.

A custom matcher is defined to let us deserialize the actual payload received (which is JSON) and compare it to a partial list of key / value pairs (as a hash):

```ruby
RSpec::Matchers.define :json_message_including do |expected|
  raise ArgumentError.new("Expected values must be a hash!") unless expected.is_a?(Hash)

  match do |actual|
    actual = JSON.parse(actual)
    expected.all? { |key, value| value == actual[key.to_s] }
  end
end
```

## Usage

Install dependencies:

```sh
bundle install
```

Run tests:

```sh
bundle exec rspec
```

## License

The code is available as open source under the terms of the [MIT License](LICENSE).
