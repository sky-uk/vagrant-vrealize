module VagrantPlugins
  module Vrealize
    module Action

      # This can be used with "Call" built-in to check if the machine
      # is created and branch in the middleware.
      class IsCreated

        def initialize(app, env)
          @app = app
        end

        NotCreatedStatuses = %i{
          not_created
          DELETED
        }

        def call(env)
          env[:result] = created?(env[:machine])
          @app.call(env)
        end

        private
        def created?(machine)
          !NotCreatedStatuses.include?(machine.state.id)
        end



      end # class IsCreated


    end
  end
end
