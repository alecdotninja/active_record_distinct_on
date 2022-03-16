require 'active_record_distinct_on/version'

require 'active_record'

module ActiveRecordDistinctOn
  autoload :DistinctOnQueryMethods, 'active_record_distinct_on/distinct_on_query_methods'

  def self.install
    ActiveRecord::Relation.include DistinctOnQueryMethods
    ActiveRecord::Querying.delegate :distinct_on, to: :all
    ActiveRecord::Relation::Merger::NORMAL_VALUES << :distinct_on
  end
end

require 'active_record_distinct_on/railtie' if defined?(Rails)
