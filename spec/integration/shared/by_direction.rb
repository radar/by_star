require 'spec_helper'

shared_examples_for 'by direction' do

  describe '#before' do

    context 'point-in-time' do
      subject { Post.before(Date.parse '2014-01-05') }
      its(:count){ should eq 3 }
    end

    context 'timespan' do
      subject { Event.before(DateTime.parse '2014-01-05') }
      its(:count){ should eq 4 }
    end

    context 'timespan strict' do
      subject { Event.before('2014-01-05', strict: true) }
      its(:count){ should eq 4 }
    end
  end

  describe '#after' do

    context 'point-in-time' do
      subject { Post.after('2014-01-05') }
      its(:count){ should eq 10 }
    end

    context 'timespan' do
      subject { Event.after(Date.parse '2014-01-05') }
      its(:count){ should eq 9 }
    end

    context 'timespan strict' do
      subject { Event.after('2014-01-05', strict: true) }
      its(:count){ should eq 9 }
    end
  end

  describe '#previous and #next' do

    context 'point-in-time' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-10 17:00:00')).first }
      it{ subject.previous.created_at.should eq Time.zone.parse('2014-01-05 17:00:00') }
      it{ subject.next.created_at.should eq Time.zone.parse('2014-01-12 17:00:00') }
    end

    context 'timespan' do
      subject { Event.where(start_time: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ subject.previous.start_time.should eq Time.zone.parse('2013-12-31 17:00:00') }
      it{ subject.next.start_time.should eq Time.zone.parse('2014-01-07 17:00:00') }
    end
  end
end
