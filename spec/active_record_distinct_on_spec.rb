require 'spec_helper'

describe ActiveRecordDistinctOn do
  it 'has a version number' do
    expect(ActiveRecordDistinctOn::VERSION).not_to be nil
  end

  describe '#install' do
    it 'mixes ActiveRecordDistinctOn:::DistinctOnQueryMethods into ActiveRecord::Relation' do
      expect(ActiveRecord::Relation).to include ActiveRecordDistinctOn::DistinctOnQueryMethods
    end

    it 'makes ActiveRecord::Relation#distinct_on available' do
      expect(ActiveRecord::Relation.instance_methods).to include :distinct_on
    end

    it 'makes ActiveRecord::Base.distinct_on available' do
      expect(ActiveRecord::Base.methods).to include :distinct_on
    end
  end
end
