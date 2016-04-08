require "log4r"
require "timeout"

module VagrantPlugins
  module Vrealize
    module Action
      # This action will wait for a machine to reach a specific state or quit by timeout
      class WaitForState
        # env[:result] will be false in case of timeout.
        # @param [Symbol] state Target machine state.
        # @param [Number] timeout Timeout in seconds.
        def initialize(app, env, state, timeout)
          @app     = app
          @logger  = Log4r::Logger.new("vagrant_vrealize::action::wait_for_state")
          @state   = state
          @timeout = timeout
        end

        def call(env)
          fail NotImplementedError
        end
      end
    end
  end
end
