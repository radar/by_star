require 'spec_helper'

shared_examples_for 'by direction' do

  describe '#before' do

    context 'point-in-time' do
      subject { Post.before(Date.parse '2014-01-05') }
      its(:count){ should eq 12 }
    end

    context 'timespan' do
      subject { Event.before(Time.parse '2014-01-05') }
      its(:count){ should eq 13 }
    end

    context 'timespan strict' do
      subject { Event.before('2014-01-05', strict: true) }
      its(:count){ should eq 13 }
    end

    context 'alternative field' do
      subject { Event.before('2014-01-05', field: 'created_at') }
      its(:count){ should eq 12 }
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

    context 'alternative field' do
      subject { Event.after('2014-01-05', field: 'created_at') }
      its(:count){ should eq 10 }
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

    context 'with scope as a query criteria' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ subject.previous({ scope: Post.where(day_of_month: subject.day_of_month) }).created_at.day.should eq subject.day_of_month }
      it{ subject.next({ scope: Post.where(day_of_month: 1) }).created_at.day.should eq 1 }
    end

    context 'with scope as a proc' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ subject.previous({ scope: Proc.new{ where(day_of_month: 5) } }).created_at.day.should eq 5 }
      it{ subject.next({ scope: ->{ where(day_of_month: 1) } }).created_at.day.should eq 1 }
      it{ subject.next({ scope: ->(klass){ klass.where(day_of_month: 1) } }).created_at.day.should eq 1 }
    end
  end
end
