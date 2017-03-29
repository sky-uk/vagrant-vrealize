$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-vrealize/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-vrealize"
  s.version       = VagrantPlugins::Vrealize::VERSION
  s.platform      = Gem::Platform::RUBY
  s.license       = "BSD-3-Clause"
  s.authors       = ["Alex Young", "David Stark"]
  s.email         = ["Alexander.Young@sky.uk", "david.stark@sky.uk"]
  s.homepage      = "https://github.com/sky-uk/vagrant-vrealize"
  s.summary       = "Enables Vagrant to manage machines in VMware VRealize."
  s.description   = "Enables Vagrant to manage machines in VMware VRealize."

  s.required_rubygems_version = "~> 1.3"

  s.add_runtime_dependency "vmware-vra", "~> 2.0.0"

  s.add_development_dependency "rake"

  s.files         = Dir.glob("{lib,example_box,locales}/**/*") +
    %w{LICENSE README.md Rakefile CONTRIBUTING.md}
  s.require_path  = 'lib'
end
