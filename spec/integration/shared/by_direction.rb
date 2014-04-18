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

    context 'with default scope' do
      subject { Appointment.before('2014-01-05', field: 'created_at') }
      its(:count){ should eq 4 }
    end

    context 'with scope as a query criteria' do
      subject { Post.before('2014-01-05', field: 'created_at', scope: Post.where(day_of_month: 5)) }
      its(:count){ should eq 1 }
    end

    context 'with scope as a proc' do
      subject { Post.before('2014-01-05', field: 'created_at', scope: ->{ where(day_of_month: 5) }) }
      its(:count){ should eq 1 }
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

    context 'with default scope' do
      subject { Appointment.after('2014-01-05', field: 'created_at') }
      its(:count){ should eq 3 }
    end

    context 'with scope as a query criteria' do
      subject { Post.after('2014-01-05', field: 'created_at', scope: Post.where(day_of_month: 5)) }
      its(:count){ should eq 1 }
    end

    context 'with scope as a proc' do
      subject { Post.after('2014-01-05', field: 'created_at', scope: ->{ where(day_of_month: 5) }) }
      its(:count){ should eq 1 }
    end
  end

  describe '#oldest and #newest' do

    context 'point-in-time' do
      it { Post.newest.created_at.should eq Time.zone.parse('2014-04-15 17:00:00') }
      it { Post.oldest.created_at.should eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'timespan' do
      it { Event.newest.created_at.should eq Time.zone.parse('2014-04-15 17:00:00') }
      it { Event.oldest.created_at.should eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'timespan strict' do
      it { Event.newest(strict: true).created_at.should eq Time.zone.parse('2014-04-15 17:00:00') }
      it { Event.oldest(strict: true).created_at.should eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'alternative field' do
      it { Event.newest(field: 'created_at').created_at.should eq Time.zone.parse('2014-04-15 17:00:00') }
      it { Event.oldest(field: 'created_at').created_at.should eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'with default scope' do
      it { Appointment.newest(field: 'created_at').created_at.should eq Time.zone.parse('2014-04-01 17:00:00') }
      it { Appointment.oldest(field: 'created_at').created_at.should eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'with scope as a query criteria' do
      it { Post.newest(field: 'created_at', scope: Post.where(day_of_month: 5)).created_at.should eq Time.zone.parse('2014-01-05 17:00:00') }
      it { Post.oldest(field: 'created_at', scope: Post.where(day_of_month: 5)).created_at.should eq Time.zone.parse('2013-12-05 17:00:00') }
    end

    context 'with scope as a proc' do
      it { Post.newest(field: 'created_at', scope: ->{ where(day_of_month: 5) }).created_at.should eq Time.zone.parse('2014-01-05 17:00:00') }
      it { Post.oldest(field: 'created_at', scope: ->{ where(day_of_month: 5) }).created_at.should eq Time.zone.parse('2013-12-05 17:00:00') }
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

    context 'with default scope' do
      subject { Appointment.where(created_at: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ subject.previous.created_at.should eq Time.zone.parse('2014-01-01 17:00:00') }
      it{ subject.next.created_at.should eq Time.zone.parse('2014-02-01 17:00:00') }
    end

    context 'with scope as a query criteria' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ subject.previous({ scope: Post.where(day_of_month: 5) }).created_at.should eq Time.zone.parse('2013-12-05 17:00:00')  }
      it{ subject.next({ scope: Post.where(day_of_month: 1) }).created_at.should eq Time.zone.parse('2014-02-01 17:00:00')  }
    end

    context 'with scope as a proc' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ subject.previous({ scope: Proc.new{ where(day_of_month: 5) } }).created_at.should eq Time.zone.parse('2013-12-05 17:00:00') }
      it{ subject.previous({ scope: Proc.new{|record| where(day_of_month: record.day_of_month) } }).created_at.should eq Time.zone.parse('2013-12-05 17:00:00') }
      it{ subject.next({ scope: ->{ where(day_of_month: 1) } }).created_at.should eq Time.zone.parse('2014-02-01 17:00:00') }
      it{ subject.next({ scope: ->(record){ where(day_of_month: record.day_of_month - 4) } }).created_at.should eq Time.zone.parse('2014-02-01 17:00:00') }
    end
  end
end
