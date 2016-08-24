require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :console do
  require 'active_record_distinct_on'
  require 'pry'

  # We have to install the monkey-patch manually here since the Railtie is not required outside of Rails
  ActiveRecordDistinctOn.install

  Pry.start
end

task :default => :spec
