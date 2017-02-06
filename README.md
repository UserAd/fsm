# Fsm

Simple FSM with events

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fsm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fsm

## Usage

```ruby

fsm = FSM.new(:initial_state).tap do |fsm|
  fsm.when :event1, initial_state: :second_state
  fsm.when :event2, second_state: :third_state
end


fsm.trigger(:event1)
puts fsm.state 

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/UserAd/fsm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

