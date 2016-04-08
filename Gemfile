source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "https://github.com/mitchellh/vagrant.git"
end

group :development, :test do
  gem "pry"
  gem "vcr"
  gem "webmock"
end

group :test do
  gem "minitest"
end

group :plugins do
  gem "vagrant-vrealize" , path: "."
end
