require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

# This installs the tasks that help with gem creation and
# publishing.
Bundler::GemHelper.install_tasks

task :console do
  require 'irb'
  require 'irb/completion'
  require 'vagrant-vrealize'
  ARGV.clear
  IRB.start
end

desc "Rebuild the boxfile."
task :box do
  sh "cd example_box && bash ./mkbox.sh"
  puts "Created example_box/vrealize.box"
end
