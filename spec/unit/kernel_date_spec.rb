require 'spec_helper'

describe Date do

  describe '#in_time_zone' do

    subject { Date.new }

    before do
      stub_const('Date', Class.new)
      Date.any_instance.stub(:to_time_in_current_zone)
    end

    context 'when #in_time_zone is already defined' do
      before do
        Date.any_instance.should_receive(:in_time_zone)
      end

      context 'when ByStar::Kernel::Date included' do
        before do
          ::Date.__send__(:include, ByStar::Kernel::Date)
        end

        it 'should not be aliased to #to_time_in_current_zone' do
          subject.should_not_receive(:to_time_in_current_zone)
          subject.in_time_zone
        end
      end

      context 'when ByStar::Kernel::Date not included' do

        it 'should not be aliased to #to_time_in_current_zone' do
          subject.should_not_receive(:to_time_in_current_zone)
          subject.in_time_zone
        end
      end
    end

    context 'when #in_time_zone is not defined' do

      context 'when ByStar::Kernel::Date included' do
        before do
          ::Date.__send__(:include, ByStar::Kernel::Date)
        end

        it 'should be aliased to #to_time_in_current_zone' do
          subject.should_receive(:to_time_in_current_zone)
          subject.in_time_zone
        end
      end

      context 'when ByStar::Kernel::Date not included' do

        it 'should raise NoMethodError' do
          ->{ subject.in_time_zone }.should raise_error(NoMethodError)
        end
      end
    end
  end
end
