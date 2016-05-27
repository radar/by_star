require 'spec_helper'

shared_examples_for 'offset parameter' do

  describe 'offset' do
    it 'should memoize the offset variable' do
      expect(Event.instance_variable_get(:@by_star_offset)).to eq 3.hours
      expect(Post.instance_variable_get(:@by_star_offset)).to be_nil
    end

    context 'between_times with default offset' do
      subject { Event.between_times(Time.zone.parse('2014-01-01'), Time.zone.parse('2014-01-10')) }
      it { expect(subject.count).to eql(7) }
    end

    context 'between_times with offset override' do
      subject { Event.between_times(Time.zone.parse('2014-01-01')..Time.zone.parse('2014-01-10'), offset: 16.hours) }
      it { expect(subject.count).to eql(7) }
    end

    context 'by_day with default offset' do
      subject { Event.by_day(Time.zone.parse('2014-01-01')) }
      it { expect(subject.count).to eql(5) }
    end

    context 'by_day with offset override' do
      subject { Event.by_day(Time.zone.parse('2014-12-26'), field: :start_time, offset: 5.hours) }
      it { expect(subject.count).to eql(0) }
    end
  end
end
