require "log4r"
require 'vra'

require 'vagrant-vrealize/vra_client'

module VagrantPlugins
  module Vrealize
    module Action

      # This action connects to VRealize, and sticks a :vra object
      # into the environment.
      class ConnectVrealize
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vrealize::action::connect_vrealize")
        end


        def call(env)
          vra = client(env)

          log_connecting(env)
          authorized = (vra.authorize!; true) rescue false

          if authorized
            store(env, vra)
          else
            env[:ui].warn("Authorisation failed")
          end
          @app.call(env)
        end


        protected

        def client(env)
          vra_conf = vra_conf(env)
          VraClient.build(username:   vra_conf.vra_username,
                          password:   vra_conf.vra_password,
                          tenant:     vra_conf.vra_tenant,
                          base_url:   vra_conf.vra_base_url,
                          verify_ssl: true)
        end


        def vra_conf(env)
          env[:machine].provider_config
        end


        def store(env, client)
          env[:vra] = client
        end


        def log_connecting(env)
          @logger.info("Connecting to #{env[:machine].provider_config.vra_base_url}")
        end

      end # class ConnectVrealize


    end
  end
end
