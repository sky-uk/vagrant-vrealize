require "log4r"
require "json"

module VagrantPlugins
  module Vrealize
    module Action
      # This terminates the running instance.
      class TerminateInstance
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vrealize::action::terminate_instance")
        end

        def call(env)
          vra = env[:vra]
          vra.destroy(env[:machine].id) if env[:machine].id

          @app.call(env)
        end
      end
    end
  end
end
