require 'active_record_distinct_on'

module ActiveRecordDistinctOn
  module DistinctOnQueryMethods
    extend ActiveSupport::Concern

    included do
      self::MULTI_VALUE_METHODS << :distinct_on
      self::INVALID_METHODS_FOR_DELETE_ALL << :distinct_on
      self::VALUE_METHODS << :distinct_on
    end

    def distinct_on_values
      @values[:distinct_on] || self.class::FROZEN_EMPTY_ARRAY
    end

    def distinct_on_values=(values)
      assert_mutability!
      @values[:distinct_on] = values
    end

    def distinct_on(*fields)
      raise ArgumentError, 'Call this with at least one field' if fields.empty?
      spawn.distinct_on!(*fields)
    end

    def distinct_on!(*fields)
      fields.flatten!
      fields.map! { |field| klass.attribute_alias?(field) ? klass.attribute_alias(field).to_sym : field }
      self.distinct_on_values += fields
      self
    end

    private

    def build_arel
      super.tap do |arel|
        build_distinct_on(arel, distinct_on_values)
      end
    end

    def build_distinct_on(arel, columns)
      arel.distinct_on arel_columns columns unless columns.empty?
    end
  end
end