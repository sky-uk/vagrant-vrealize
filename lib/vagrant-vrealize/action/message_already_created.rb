require 'i18n'

module VagrantPlugins
  module Vrealize
    module Action
      class MessageAlreadyCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_vrealize.already_status", status: "created"))
          @app.call(env)
        end
      end
    end
  end
end
