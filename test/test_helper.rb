require 'minitest/autorun'
require 'vcr'

require 'vagrant-vrealize/action'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

$LOAD_PATH << "lib"

module TestHelpers
  def StubbingVra(cassette_name, &blk)
    VCR.use_cassette(cassette_name, record: :none, &blk)
  end
end

class VrealizeTest < Minitest::Test
  include TestHelpers
end

class VrealizeActionTest < VrealizeTest
  include VagrantPlugins::Vrealize::Action
end
