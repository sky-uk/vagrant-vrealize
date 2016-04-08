require 'test_helper'

require 'vagrant-vrealize/action/connect_vrealize'

class ConnectVrealizeTest < VrealizeActionTest

  def test_bad_credentials_gives_no_connection
    StubbingVra("unsuccessful_auth") do
      provider_config = {
        vra_username: "BadUsername",
        vra_password: "BadPassword",
        vra_tenant: "vsphere.local",
        vra_base_url: "https://e2portal"
      }
      env = env_for_provider_config(provider_config)
      app = ->{fail "Shouldn't be called"}

      # slightly odd api here, we pass the env in twice
      action = ConnectVrealize.new(app, env)
      action.call(env)
      assert(env[:vra].nil?, "A connection object was created.")
    end
  end


  def test_good_credentials_gives_a_connection
    StubbingVra("successful_auth") do
      provider_config = {
        vra_username: "MyUsername",
        vra_password: "MyPassword",
        vra_tenant: "vsphere.local",
        vra_base_url: "https://e2portal"
      }
      env = env_for_provider_config(provider_config)

      called = false
      app = ->(_){called = true}

      action = ConnectVrealize.new(app, env)
      action.call(env)
      assert called, "The app wasn't called"
      assert(env[:vra], "No connection object was created.")
    end
  end


  private
  def env_for_provider_config(config)
    {machine: OpenStruct.new(provider_config: OpenStruct.new(config))}
  end

end
