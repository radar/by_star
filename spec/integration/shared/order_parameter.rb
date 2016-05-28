require 'spec_helper'

shared_examples_for 'order parameter' do

  describe ':order' do

    if testing_active_record?

      it 'should be able to order the result set asc' do
        scope = Post.by_year(Time.zone.now.year, order: 'created_at ASC')
        expect(scope.order_values).to eq ['created_at ASC']
        expect(scope.first.created_at).to eq Time.zone.parse('2014-01-01 17:00:00')
      end

      it 'should be able to order the result set desc' do
        scope = Post.by_year(Time.zone.now.year, order: 'created_at DESC')
        expect(scope.order_values).to eq ['created_at DESC']
        expect(scope.first.created_at).to eq Time.zone.parse('2014-04-15 17:00:00')
      end

    elsif testing_mongoid?

      it 'should be able to order the result set asc' do
        scope = Post.by_year(Time.zone.now.year, order: {created_at: :asc})
        expect(scope.options[:sort]).to eq({'created_at' => 1})
        expect(scope.first.created_at).to eq Time.zone.parse('2014-01-01 17:00:00')
      end

      it 'should be able to order the result set desc' do
        scope = Post.by_year(Time.zone.now.year, order: {created_at: :desc})
        expect(scope.options[:sort]).to eq({'created_at' => -1})
        expect(scope.first.created_at).to eq Time.zone.parse('2014-04-15 17:00:00')
      end
    end
  end
end
