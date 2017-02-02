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

          # Destroy action_provision
          action_provision_file = env[:machine].data_dir.join('action_provision')
          if action_provision_file.file?
            action_provision_file.delete
          end

          # Destroy creator_uid
          creator_uid_file = env[:machine].data_dir.join('creator_uid')
          if creator_uid_file.file?
            creator_uid_file.delete
          end

          # Destroy elastic_ip
          elastic_ip_file = env[:machine].data_dir.join('elastic_ip')
          if elastic_ip_file.file?
            elastic_ip_file.delete
          end

          # Destroy id
          id_file = env[:machine].data_dir.join('id')
          if id_file.file?
            id_file.delete
          end

          # Destroy index_uuid
          index_uuid_file = env[:machine].data_dir.join('index_uuid')
          if index_uuid_file.file?
            index_uuid_file.delete
          end

          # Destroy private_key
          private_key_file = env[:machine].data_dir.join('private_key')
          if private_key_file.file?
            private_key_file.delete
          end

          # Destroy synced_folders
          synced_folders_file = env[:machine].data_dir.join('synced_folders')
          if synced_folders_file.file?
            synced_folders_file.delete
          end

          @app.call(env)
        end
      end
    end
  end
end
