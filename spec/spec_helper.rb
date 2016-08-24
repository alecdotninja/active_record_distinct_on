$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_record'
require 'active_record_distinct_on'

ActiveRecordDistinctOn.install