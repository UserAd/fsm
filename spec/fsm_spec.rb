require "spec_helper"

describe FSM do

  before(:each) do
    @machine = FSM.new(:pending)
    @machine.when(:confirm, pending: :confirmed)
    @machine.when(:ignore, pending: :ignored)
    @machine.when(:reset, confirmed: :pending, ignored: :pending, tested: :pending)
    @machine.when(:test_star, :* => :tested)
  end

  it "returns an array with the defined events" do
    expect(@machine.events).to eq([:confirm, :ignore, :reset, :test_star])
  end

  it "returns an array with the defined states" do
    expect(@machine.states).to eq([:pending, :confirmed, :ignored, :tested, :*])
  end

  it "changes the state if transition is possible" do
    expect(@machine.trigger?(:confirm)).to eq(true)
    expect(@machine.trigger(:confirm)).to eq(true)
    expect(@machine.state).to eq(:confirmed)
  end

  it "not changes the state if transition is not possible" do
    expect(@machine.trigger?(:reset)).to eq(false)
    expect(@machine.trigger(:reset)).to eq(false)
    expect(@machine.state).to eq(:pending)
  end

  it "Fire event when state changed" do
    new_event_name = nil
    @machine.on :state_changed do |event_name, changeset|
      new_event_name = event_name
    end
    @machine.trigger(:confirm)
    expect(new_event_name).to eq(:confirm)
  end

  it "Fire named event when state changed" do
    new_state = nil
    @machine.on :confirmed do |state|
      new_state = state
    end
    @machine.trigger(:confirm)
    expect(new_state).to eq(:confirm)
  end

  it "Changes state to tested if :test_star fired" do
    new_state = nil
    @machine.on :state_changed do |_event, state|
      new_state = state[:to]
    end
    @machine.trigger(:test_star)
    expect(new_state).to eq(:tested)
  end

  it "Creates dot graph" do
    fsm = FSM.new(:initial_state).tap do |fsm|
      fsm.when :star, :* => :starred
      fsm.when :event1, initial_state: :second_state
      fsm.when :event2, second_state: :third_state
    end

    expect(fsm.to_dot).to eq("digraph finite_state_machine {\n  node [shape = circle];\n  initial_state -> second_state [label=\"event1\"];\nsecond_state -> third_state [label=\"event2\"];\n}\n")
  end

end
