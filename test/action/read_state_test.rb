require 'test_helper'

require 'vagrant-vrealize/vra_client'
require 'vagrant-vrealize/action/read_state'

class ReadStateTest < VrealizeActionTest
  module States
    Active = "ACTIVE"
    Pending = "PENDING_APPROVAL"
    Rejected = "REJECTED"
    Deleted = "DELETED"
  end


  def test_not_created_with_no_machine
    no_machine_env = {machine: OpenStruct.new(id: nil)}
    action = ReadState.new(->(_){}, {})

    action.call(no_machine_env)
    assert_equal(:not_created, no_machine_env[:machine_state_id])
  end

  def vra
    VagrantPlugins::Vrealize::VraClient.build(
        username: "MyUsername",
        password: "MyPassword",
        tenant: "vsphere.local",
        base_url: "https://e2portal"
    )
  end

  {
    States::Active => 'get_active_vm_state',
    States::Pending => 'get_pending_vm_state'
  }.each do |ok_state, cassette|
    define_method("test_#{ok_state}_machine_gives_state_id") do
      running_machine_env = {
        vra: vra,
        machine: OpenStruct.new(id: 42,
                                state: ok_state)
      }
      action = ReadState.new(->(_){}, {})

      StubbingVra(cassette) do
        action.call(running_machine_env)
      end

      assert_equal(ok_state.to_sym, running_machine_env[:machine_state_id])
    end
  end
end
