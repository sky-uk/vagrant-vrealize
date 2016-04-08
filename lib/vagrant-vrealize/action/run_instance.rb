require "log4r"
require 'json'

require 'vagrant/util/retryable'

require 'vagrant-vrealize/util/timer'

module VagrantPlugins
  module Vrealize
    module Action
      # This runs the configured instance.
      class RunInstance
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vrealize::action::run_instance")
        end

        # There are more literal types than this, but we don't support them yet

        def create_resource(env)
          env[:ui].info("Creating machine")

          config = env[:machine].provider_config
          vra = env[:vra]

          EntitledItemsCollection.fetch(env[:vra])
            .find_by_id(config.catalog_item_id)
            .request(cpus:          config.cpus,
                     memory:        config.memory,
                     requested_for: config.requested_for,
                     subtenant_id:  config.subtenant_id,
                     lease_days:    config.lease_days) { |req|
              config.extra_entries.types.each do |type|
                config.extra_entries.of_type(type).each do |k,v|
                  req.set_parameter(k, type, v)
                end
              end
            }
            .join
            .machine
        end

        def wait_for_ssh(env)
          if !env[:interrupted]
            env[:metrics]["instance_ssh_time"] = Util::Timer.time do
              # Wait for SSH to be ready.
              env[:ui].info(I18n.t("vagrant_vrealize.waiting_for_ssh"))
              network_ready_retries = 0
              network_ready_retries_max = 10
              loop do
                # If we're interrupted then just back out
                break if env[:interrupted]
                begin
                  break if env[:machine].communicate.ready?
                rescue => e
                  if network_ready_retries < network_ready_retries_max then
                    network_ready_retries += 1
                    @logger.warn(I18n.t("vagrant_vrealize.waiting_for_ssh, retrying"))
                  else
                    raise e
                  end
                end
                sleep 2
              end
            end
          end
        end

        def save_ip_address(env, resource)
          env[:machine].data_dir.join('elastic_ip').open("w+") do |f|
            f.write({:public_ip => resource.ip_addresses.first}.to_json)
          end
        end

        def call(env)
          vra = env[:vra] or fail "No VRA client instance!"

          # Initialize metrics if they haven't been
          env[:metrics] ||= {}

          created_resource = create_resource(env)
          env[:machine].id = created_resource.id
          save_ip_address(env, created_resource)
          wait_for_ssh(env)
          terminate(env) if env[:interrupted]

          @app.call(env)
        end

        def recover(env)
          return if env["vagrant.error"].is_a?(Vagrant::Errors::VagrantError)

          if env[:machine].provider.state.id != :not_created
            # Undo the import
            terminate(env)
          end
        end

        def terminate(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Action.action_destroy, destroy_env)
        end
      end
    end
  end
end
