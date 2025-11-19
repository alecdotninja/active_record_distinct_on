require 'active_record_distinct_on'
module ActiveRecordDistinctOn
  module DistinctOnQueryMethods
    extend ActiveSupport::Concern

    FROZEN_EMPTY_ARRAY = [].freeze

    included do
      self::MULTI_VALUE_METHODS << :distinct_on
      if defined?(self::INVALID_METHODS_FOR_UPDATE_AND_DELETE_ALL)
        self::INVALID_METHODS_FOR_UPDATE_AND_DELETE_ALL << :distinct_on
      else
        self::INVALID_METHODS_FOR_DELETE_ALL << :distinct_on
      end
      self::VALUE_METHODS << :distinct_on
      self::DEFAULT_VALUES[:distinct_on] = FROZEN_EMPTY_ARRAY if defined?(self::DEFAULT_VALUES)
    end

    def distinct_on_values
      @values[:distinct_on] || FROZEN_EMPTY_ARRAY
    end

    def distinct_on_values=(values)
      @values[:distinct_on] = values
    end

    def distinct_on(*fields)
      raise ArgumentError, 'Call this with at least one field' if fields.empty?
      spawn.distinct_on!(*fields)
    end

    def distinct_on!(*fields)
      fields.flatten!
      self.distinct_on_values += fields
      self
    end

    def count(column_name = nil)
      if distinct_on_values.empty?
        super
      else
        if column_name && column_name != :all
          raise ArgumentError,
                "Cannot use column_name to .count for scopes that already specify `distinct_on` values"
        end

        # See https://github.com/rails/rails/pull/41622#issuecomment-1303078730
        # We need to convert SQL that looks like "SELECT DISTINCT ON ( "dogs"."id" ) COUNT(*) FROM "dogs" ..."
        # into SQL that looks like "SELECT COUNT(DISTINCT ( "dogs"."id" )) FROM "dogs" ...".
        scope = spawn
        scope.distinct_on_values = FROZEN_EMPTY_ARRAY

        column_names = distinct_on_arel_columns.map do |col|
          "\"#{col.relation.name}\".\"#{col.name}\""
        end

        scope.count("distinct(#{column_names.join(', ')})")
      end
    end

    private

    def build_arel(*)
      super.tap do |arel|
        build_distinct_on(arel)
      end
    end

    def build_distinct_on(arel)
      return if distinct_on_values.empty?

      arel.distinct_on(distinct_on_arel_columns)
    end

    def distinct_on_arel_columns
      arel_attributes = distinct_on_values.map do |field|
        if field.is_a?(String)
          field
        elsif field.is_a?(Hash)
          assoc = field.keys.first
          assoc_klass = klass.reflect_on_association(assoc).klass
          assoc_field = field[assoc].to_sym
          build_distinct_on_field(assoc_klass, assoc_field)
        else
          build_distinct_on_field(klass, field)
        end
      end

      arel_columns(arel_attributes)
    end

    def build_distinct_on_field(klass, field)
      return klass.arel_table[klass.attribute_alias(field).to_sym] if klass.attribute_alias?(field)

      klass.arel_table[field]
    end
  end
end
