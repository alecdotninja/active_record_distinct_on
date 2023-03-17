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

    context '.count queries' do
      it 'supports count queries in conjunction with distinct_on' do
        dog = Dog.create!(
          id: 1,
          name: 'dogname',
        )
        toy = Toy.create!(
          id: 2,
          name: 'toyname',
        )
        2.times do
          DogToToys.create!(
            dog_id: dog.id,
            toy_id: toy.id
          )
        end

        expect(Dog.joins(:toys).count).to eq 2
        expect(Dog.joins(:toys).where(name: 'dogname').count).to eq 2
        expect(Dog.joins(:toys).where(name: 'toyname').count).to eq 0
        expect(Dog.joins(:toys).where(toys: { name: 'toyname' }).count).to eq 2
        expect(Dog.joins(:toys).distinct_on(:id).count).to eq 1
        expect(Dog.joins(:toys).distinct_on(:id).where(name: 'dogname').count).to eq 1
        expect(Dog.joins(:toys).distinct_on(:id).where(name: 'toyname').count).to eq 0
        expect(Dog.joins(:toys).distinct_on(:id).where(toys: { name: 'toyname' }).count).to eq 1

        expect(Dog.joins(:toys).size).to eq 2
        expect(Dog.joins(:toys).where(name: 'dogname').size).to eq 2
        expect(Dog.joins(:toys).where(name: 'toyname').size).to eq 0
        expect(Dog.joins(:toys).where(toys: { name: 'toyname' }).size).to eq 2
        expect(Dog.joins(:toys).distinct_on(:id).size).to eq 1
        expect(Dog.joins(:toys).distinct_on(:id).where(name: 'dogname').size).to eq 1
        expect(Dog.joins(:toys).distinct_on(:id).where(name: 'toyname').size).to eq 0
        expect(Dog.joins(:toys).distinct_on(:id).where(toys: { name: 'toyname' }).size).to eq 1
      end
    end
  end
end
