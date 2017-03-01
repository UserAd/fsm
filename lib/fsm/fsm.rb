require 'event_emitter'

class FSM
  include EventEmitter
  InvalidEvent = Class.new(NoMethodError)
  InvalidState = Class.new(ArgumentError)

  attr_reader :transitions_for, :state

  def initialize(initial_state, emitter=nil)
    @state = initial_state
    @transitions_for = Hash.new
    @emitter = emitter
  end

  def force_state(state)
    @state = state
  end

  def when(event, transitions)
    transitions_for[event] = Hash.new if transitions_for[event].nil?
    transitions_for[event].merge!(transitions)
  end

  def trigger(event, *args)
    trigger?(event) && change(event, args)
  end

  def trigger!(event)
    raise InvalidState.new("Event '#{event}' not valid from state '#{@state}'") unless trigger(event)
  end

  def trigger?(event)
    transitions_for.has_key?(event) && (transitions_for[event].has_key?(state) || transitions_for[event].has_key?(:*))
  end

  def events
    transitions_for.keys
  end

  def states
    transitions_for.values.map(&:to_a).flatten.uniq
  end

  def to_dot
    dot_states = transitions_for.collect do |event, states|
      states.collect do |src, dst|
        "#{src.to_s} -> #{dst.to_s} [label=\"#{event}\"];" unless src.to_s == "*"
      end
    end.flatten.compact

<<-END
digraph finite_state_machine {
  node [shape = circle];
  #{dot_states.join("\n")}
}
    END
  end

  private

  def emitter
    @emitter || self
  end


  def change(event, args)
    old_state = @state
    @state = :* if transitions_for[event].has_key?(:*)
    @state = transitions_for[event][@state]

    return false if old_state == @state

    emitter.emit(@state.to_s, event, *args)
    emitter.emit(:state_changed, event, {from: old_state, to: @state})

    true
  end

end
