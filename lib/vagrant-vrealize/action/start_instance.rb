require "log4r"

require 'vagrant/util/retryable'

require 'vagrant-vrealize/util/timer'

module VagrantPlugins
  module Vrealize
    module Action
      # This starts a stopped instance.
      class StartInstance
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vrealize::action::start_instance")
        end

        def call(env)
          fail NotImplementedError
        end
      end
    end
  end
end
