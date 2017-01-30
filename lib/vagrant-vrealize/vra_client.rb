require 'vra'

module VagrantPlugins
  module Vrealize

    class VraClient

      def self.build(vra_params)
        pagination_bugfix_params = {page_size: 100}.merge(vra_params)
        new(Vra::Client.new(pagination_bugfix_params))
      end


      def initialize(client)
        @client = client
      end


      def authorize!
        @client.authorize!
      end


      def resources
        @client.resources
      end


      def entitled_catalog_items
        @client.catalog.entitled_items
      end

      def request(catalog_item_id,params)
        req = @client.catalog.request(catalog_item_id, params)
        yield req if block_given?
        req.submit
      end

      def ssh_info(machine_id)
        resource = @client.resources.by_id(machine_id)
        host = resource.ip_addresses.first

        {host: host, port: 22}
      end

      def destroy(machine_id)
        resource = @client.resources.by_id(machine_id)
        if resource
          resource.destroy
        end
      end


    end # class VraClient


    class EntitledItemsCollection
      def self.fetch(vra)
        new(vra, vra.entitled_catalog_items)
      end

      def initialize(vra, entitled_items)
        @vra = vra
        @entitled_items = entitled_items
      end

      def find(&blk)
        found_item = @entitled_items.find(&blk)
        raise "No catalog item was found." unless found_item
        CatalogRequest.new(@vra, found_item.id)
      end

      def find_by_name(name)
        find{|item| item.name == name}
      end

      def find_by_id(id)
        find{|item| item.id == id}
      end
    end

    class CatalogRequest
      def initialize(vra, catalog_item_id)
        @vra = vra
        @catalog_item_id = catalog_item_id
      end

      def request(params, &blk)
        new_item_request = @vra.request(@catalog_item_id, params) { |cat_req|
          yield cat_req if blk
        }
        SubmittedItemRequest.new(@vra, new_item_request)
      end
    end

    class SubmittedItemRequest
      def initialize(vra, request)
        @vra = vra
        @request = request
      end

      def machine
        if done?
          # expecting only one VM, but should check and error out if there are more
          @request.resources.select { |a| a.vm? }.first
        end
      end

      def join
        while !done?
          fail "Creating the machine failed: #{@request.status}" if failed?
          sleep 5
        end
        self
      end

      OkStates = %w{
        SUCCESSFUL
        IN_PROGRESS
        PENDING_PRE_APPROVAL
        PENDING_POST_APPROVAL
      }

      private
      def done?
        begin
          @request.refresh # TODO - this can except if Service Temporarily Unavailable
          @request.status == "SUCCESSFUL"
        end
      end

      def failed?
        @request.refresh
        !OkStates.include?(@request.status)
      end

    end


  end
end
