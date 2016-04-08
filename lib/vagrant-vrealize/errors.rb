require "vagrant"

module VagrantPlugins
  module Vrealize
    module Errors
      class VagrantVrealizeError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_vrealize.errors")
      end

      class InstanceReadyTimeout < VagrantVrealizeError
        error_key(:instance_ready_timeout)
      end

      class InstancePackageError < VagrantVrealizeError
        error_key(:instance_package_error)
      end

      class InstancePackageTimeout < VagrantVrealizeError
        error_key(:instance_package_timeout)
      end

      class RsyncError < VagrantVrealizeError
        error_key(:rsync_error)
      end

      class MkdirError < VagrantVrealizeError
        error_key(:mkdir_error)
      end

    end
  end
end
