require "log4r"
require "json"

module VagrantPlugins
  module Vrealize
    module Action
      # This terminates the running instance.
      class TerminateInstance

        STATE_FILENAMES = %w{
          action_provision
          creator_uid
          elastic_ip
          id
          index_uuid
          private_key
          synced_folders
        }

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vrealize::action::terminate_instance")
        end

        def call(env)
          vra = env[:vra]
          vra.destroy(env[:machine].id) if env[:machine].id

          clean_up_data_dir(env[:machine])

          @app.call(env)
        end

        private

        def clean_up_data_dir(machine)
          # Destroy leftover state
          STATE_FILENAMES
            .map{|filename| machine.data_dir.join(filename) }
            .select(&:file?)
            .each(&:delete)
        end
      end
    end
  end
end
