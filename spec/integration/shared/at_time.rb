require 'spec_helper'

shared_examples_for 'at_time' do

  describe '#at_time' do

    context 'point object' do

      context 'exactly equal' do
        subject { Post.at_time(Time.zone.parse('2013-12-28 17:00:00')) }
        it { expect(subject.count).to eql(1) }
      end

      context 'not exactly equal' do
        subject { Post.at_time(Time.zone.parse('2013-12-28 17:00:01')) }
        it { expect(subject.count).to eql(0) }
      end
    end

    context 'timespan object' do

      context 'before start time' do
        subject { Event.at_time(Time.zone.parse('2013-12-23 16:59:59')) }
        it { expect(subject.count).to eql(2) }
      end

      context 'at start time' do
        subject { Event.at_time(Time.zone.parse('2013-12-23 17:00:00')) }
        it { expect(subject.count).to eql(3) }
      end

      context 'after start time' do
        subject { Event.at_time(Time.zone.parse('2013-12-23 17:00:01')) }
        it { expect(subject.count).to eql(3) }
      end

      context 'before end time' do
        subject { Event.at_time(Time.zone.parse('2013-11-06 16:59:59')) }
        it { expect(subject.count).to eql(1) }
      end

      context 'at end time' do
        subject { Event.at_time(Time.zone.parse('2013-11-06 17:00:00')) }
        it { expect(subject.count).to eql(0) }
      end

      context 'after end time' do
        subject { Event.at_time(Time.zone.parse('2013-11-06 17:00:01')) }
        it { expect(subject.count).to eql(0) }
      end
    end
  end
end
