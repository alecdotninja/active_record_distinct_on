require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'appraisal/task'

RSpec::Core::RakeTask.new(:spec)
task :test => :spec

Appraisal::Task.new

namespace :test do
  task :all => :appraisal
end

task :console do
  require 'active_record_distinct_on'
  require 'pry'

  # We have to install the monkey-patch manually here since the Railtie is not required outside of Rails
  ActiveRecordDistinctOn.install

  Pry.start
end

task :default => :test
