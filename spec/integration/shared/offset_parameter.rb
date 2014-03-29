require 'spec_helper'

shared_examples_for 'offset parameter' do

  describe 'offset' do
    it 'should memoize the offset variable' do
      Event.instance_variable_get(:@by_star_offset).should eq 3.hours
      Post.instance_variable_get(:@by_star_offset).should be_nil
    end

    context 'between_times with model offset' do
      subject { Event.between_times(Time.parse('2014-01-01'), Time.parse('2014-01-10')) }
      its(:count) { should eq 7 }
    end

    context 'between_times with offset override' do
      subject { Event.between_times(Time.parse('2014-01-01'), Time.parse('2014-01-10'), offset: 16.hours) }
      its(:count) { should eq 7 }
    end

    context 'by_day with model offset' do
      subject { Event.by_day(Time.parse('2014-01-01')) }
      its(:count) { should eq 5 }
    end

    context 'by_day with offset override' do
      subject { Event.by_day(Time.parse('2014-12-26'), field: :start_time, offset: 5.hours) }
      its(:count) { should eq 0 }
    end
  end
end
