require "vagrant"
require "vagrant-vrealize/extra-entries"

module VagrantPlugins
  module Vrealize
    class Config < Vagrant.plugin("2", :config)

      def initialize(*args, &blk)
        @vra_username =
          @vra_password =
          @vra_tenant =
          @vra_base_url =
          @subtenant_id =
          @catalog_item_id =
          @requested_for =
          UNSET_VALUE

        @cpus = 1
        @memory = 1024
        @lease_days = 5

        @__extra_entries = ExtraEntries.new
        super
      end

      #
      # The username for accessing the VRealize instance.
      #
      # @return [String]
      attr_accessor :vra_username

      #
      # The password for accessing the VRealize instance.
      #
      # @return [String]
      attr_accessor :vra_password


      #
      # The tenant to own the requested resource.
      #
      # @return [String]
      attr_accessor :vra_tenant


      #
      # The VRealize endpoint URL.
      #
      # @return [String]
      attr_accessor :vra_base_url


      #
      attr_accessor :subtenant_id
      attr_accessor :catalog_item_id
      attr_accessor :requested_for, :cpus, :memory, :lease_days

      def add_entries
        yield @__extra_entries
      end

      def extra_entries
        @__extra_entries
      end

      def validate(machine)
        errors = _detected_errors()
        validation_failures =
          [
            validate_vra_username(),
            validate_vra_password(),
            validate_vra_username(),
            validate_vra_password(),
            validate_vra_tenant(),
            validate_vra_base_url(),
            validate_requested_for(),
            validate_subtenant_id(),
            validate_catalog_item_id(),
            validate_memory()
          ].compact

        validation_failures.each do |msg|
          errors << msg
        end

        {'Vrealize provider' => errors}
      end

      private
      def validate_cpu(errors)
        errors << "cpus required" if @cpus == UNSET_VALUE ||
                                     @cpus.nil? ||
                                     @cpus == 0
      end

      def unset?(str)
        @vra_username == UNSET_VALUE ||
          @vra_username.nil? ||
          @vra_username.empty?
      end

      def validate_vra_username
        "vra_username required" if unset?(@vra_username)
      end

      def validate_vra_password
        "vra_password required" if unset?(@vra_password)
      end

      def validate_vra_tenant
        "vra_tenant required" if unset?(@vra_tenant)
      end

      def validate_vra_base_url
        "vra_base_url required" if unset?(@vra_base_url)
      end

      def validate_requested_for
        "requested_for required" if unset?(@requested_for)
      end

      def validate_subtenant_id
        "subtenant_id required" if unset?(@subtenant_id)
      end

      def validate_catalog_item_id
        "catalog_item_id required" if unset?(@catalog_item_id)
      end

      def validate_memory
        "memory required" if @memory == UNSET_VALUE ||
                             @memory.nil? ||
                             @memory == 0
      end

    end
  end
end
