require "log4r"

module VagrantPlugins
  module Vrealize
    module Action
      # This stops the running instance.
      class StopInstance
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vrealize::action::stop_instance")
        end

        def call(env)
          fail NotImplementedError
        end
      end
    end
  end
end
