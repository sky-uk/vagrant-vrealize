require 'test_helper'

require 'vagrant/machine_state'
require 'vagrant-vrealize/action/is_created'

class IsCreatedTest < VrealizeActionTest
  UncreatedState = :not_created
  NotUncreatedState = :anything_else

  def test_is_not_yet_created
    env = env_with_machine_state(UncreatedState)

    action = IsCreated.new(->(_){}, env)
    action.call(env)

    refute(env[:result], "Machine was reported as created")
  end


  def test_is_created
    env = env_with_machine_state(NotUncreatedState)

    action = IsCreated.new(->(_){}, env)
    action.call(env)

    assert(env[:result], "Machine was reported as uncreated")
  end

  def test_not_implemented_yet
    fail "We haven't figured out how the machine state ends up in env[:result] yet"
  end

  private
  def env_with_machine_state(state_id)
    machine_state = Vagrant::MachineState.new(state_id, "short_desc", "long_desc")
    {machine: OpenStruct.new(state: machine_state)}
  end
end
