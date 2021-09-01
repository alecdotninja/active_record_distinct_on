# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_distinct_on/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_record_distinct_on'
  spec.version       = ActiveRecordDistinctOn::VERSION
  spec.authors       = ['Alec Larsen']
  spec.email         = ['hello@alec.ninja']

  spec.summary       = %q{Adds support for `DISTINCT ON` statements when querying with ActiveRecord}
  spec.description   = %q{ActiveRecordDistinctOn adds support for `DISTINCT ON` to ActiveRecord. At the time of this writing, PostgreSQL is the only database which supports this syntax; however, this gem has been written with database independence in mind so that if another Arel visitor adds support for `Arel::Nodes::DistinctOn` in the future, it should work seamlessly.}
  spec.homepage      = 'https://github.com/alecdotninja/active_record_distinct_on'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = %w{ lib }

  spec.add_dependency 'activerecord', '>= 5.2', '< 6.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov', '0.18.1'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'sqlite3'
end
