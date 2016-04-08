require "log4r"

module VagrantPlugins
  module Vrealize
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class ReadState
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vrealize::action::read_state")
        end

        def call(env)
          env[:machine_state_id] = read_state(env[:vra],env[:machine])
        end

        def read_state(vra, machine)
          return :not_created if machine.id.nil?

          resource = vra.resources.by_id(machine.id)

          return resource.status.to_sym
        end
      end
    end
  end
end
