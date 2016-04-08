require 'vcr'
require 'vra'
require 'pry'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data('MyUsername'){ ENV['USER'] }
  config.filter_sensitive_data('MyPassword'){ ENV['PASSWORD'] }
end


vra = Vra::Client.new(username: ENV['USER'],
                      password: ENV['PASSWORD'],
                      tenant: "vsphere.local",
                      base_url: "https://e2portal",
                      verify_ssl: true)

def record(name, &blk)
  puts "Recording #{name}"
  VCR.use_cassette(name, &blk)
end

record("unsuccessful_auth") do
  bad_vra = Vra::Client.new(username: "BadUsername",
                            password: "BadPassword",
                            tenant: "vsphere.local",
                            base_url: "https://e2portal",
                            verify_ssl: true)
  begin
    bad_vra.authorize!
  rescue
    #ignore
  end
end

record("successful_auth") do
  vra.authorize!
end

record("get_all_resources_when_empty") do
  vra.resources.all_resources
end

entitled_items = record("get_entitled_items") do
  vra.catalog.entitled_items
end

catalog_item = entitled_items.find{|item| item.name == "Elements Ubuntu 14.04 LTS"}

catalog_request = record("make_request") do
  params = {
    cpus: 1,
    memory: 1024,
    requested_for: ENV['USER'].upcase+"@bskyb.com",
    subtenant_id: "f04f060d-73be-48a3-b82c-20cb98efd2d2",
    lease_days: 5
  }
  req = vra.catalog.request(catalog_item.id, params)
  req.set_parameter('provider-Vrm.DataCenter.Location', 'string', '')
  req
end

request = record("submit_request") do
  catalog_request.submit
end

def get_request_status(vra, request_id)
  new_request = vra.requests.by_id(request_id)
  new_request.status
end

status = record("get_in_progress_status") do
  s = get_request_status(vra, request.id)
  s
end

if !File.exist?("spec/fixtures/vcr_cassettes/get_done_status.yml")
  VCR.turned_off {
    begin
      WebMock.disable!
      while (s = get_request_status(vra, request.id)) == "IN_PROGRESS"
        puts "Waiting for status != IN_PROGRESS"
        p s
        sleep(5)
      end
    ensure
      WebMock.enable!
    end
  }
end

status = record("get_done_status") do
  get_request_status(vra, request.id)
end

unless status == "SUCCESSFUL"
  fail "Transaction recording broken; request was #{status} not SUCCESSFUL"
end

record("get_all_resources") do
  resources = vra.resources.all_resources
  record("get_active_resource_by_id") do
    id = resources.first.id
    vra.resources.by_id(id)
  end
end
