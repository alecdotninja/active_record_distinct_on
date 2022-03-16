require 'spec_helper'

describe ActiveRecordDistinctOn::DistinctOnQueryMethods do
  let(:dummy_model) { Dog }
  let(:dummy_model_attribute_names) { Dog.column_names }

  subject { dummy_model.all }

  describe '#distinct_on' do
    context 'with no arguments' do
      it 'raises an ArgumentError' do
        expect { subject.distinct_on }.to raise_error ArgumentError
      end
    end

    context 'with arguments' do
      let(:attribute_names) { dummy_model_attribute_names.sample(3) }
      let(:arel) { subject.distinct_on(*attribute_names).arel }
      let(:select_statement) { arel.ast }
      let(:set_quantifies) { select_statement.cores.map(&:set_quantifier) }
      let(:set_quantifier_attributes) { set_quantifies.flat_map(&:expr) }
      let(:set_quantifier_attribute_names) { set_quantifier_attributes.map(&:name) }

      it 'produces arel with a single set_quantifier' do
        expect(set_quantifies.count).to eq 1
      end

      it 'produces arel with a Arel::Nodes::DistinctOn set_quantifier' do
        expect(set_quantifies.first).to be_a Arel::Nodes::DistinctOn
      end

      it 'produces arel with a set_quantifier over the correct attribute_names' do
        expect(set_quantifier_attribute_names).to eq attribute_names
      end
    end

    context 'when chained' do
      it 'behaves the same as having been called once with all of the arguments' do
        expect(subject.distinct_on(:a).distinct_on(:b, :c).distinct_on_values).to(
          eq(subject.distinct_on(:a, :b, :c).distinct_on_values)
        )
      end
    end

    context 'when in a scope' do
      it 'gets copied from the scope' do
        expect(dummy_model.new.toys.scope.distinct_on_values).to eq [:id]
      end
    end
  end
end
