require 'spec_helper'

shared_examples_for 'by direction' do

  describe '#before' do

    context 'point-in-time' do
      subject { Post.before(Date.parse '2014-01-05') }
      it { expect(subject.count).to eql(12) }
    end

    context 'timespan default' do
      subject { Event.before(Time.zone.parse '2014-01-05') }
      it { expect(subject.count).to eql(13) }
    end

    context 'timespan strict' do
      subject { Event.before('2014-01-05', strict: true) }
      it { expect(subject.count).to eql(13) }
    end

    context 'timespan not strict' do
      subject { Event.before('2014-01-05', strict: false) }
      it { expect(subject.count).to eql(13) }
    end

    context 'alternative field' do
      subject { Event.before('2014-01-05', field: 'created_at') }
      it { expect(subject.count).to eql(12) }
    end

    context 'with default scope' do
      subject { Appointment.before('2014-01-05', field: 'created_at') }
      it { expect(subject.count).to eql(4) }
    end

    context 'with scope as a query criteria' do
      subject { Post.before('2014-01-05', field: 'created_at', scope: Post.where(day_of_month: 5)) }
      it { expect(subject.count).to eql(1) }
    end

    context 'with scope as a proc' do
      subject { Post.before('2014-01-05', field: 'created_at', scope: ->{ where(day_of_month: 5) }) }
      it { expect(subject.count).to eql(1) }
    end
  end

  describe '#after' do

    context 'point-in-time' do
      subject { Post.after('2014-01-05') }
      it { expect(subject.count).to eql(10) }
    end

    context 'timespan default' do
      subject { Event.after(Date.parse '2014-01-05') }
      it { expect(subject.count).to eql(9) }
    end

    context 'timespan strict' do
      subject { Event.after('2014-01-05', strict: true) }
      it { expect(subject.count).to eql(9) }
    end

    context 'timespan not strict' do
      subject { Event.after('2014-01-05', strict: false) }
      it { expect(subject.count).to eql(9) }
    end

    context 'alternative field' do
      subject { Event.after('2014-01-05', field: 'created_at') }
      it { expect(subject.count).to eql(10) }
    end

    context 'with default scope' do
      subject { Appointment.after('2014-01-05', field: 'created_at') }
      it { expect(subject.count).to eql(3) }
    end

    context 'with scope as a query criteria' do
      subject { Post.after('2014-01-05', field: 'created_at', scope: Post.where(day_of_month: 5)) }
      it { expect(subject.count).to eql(1) }
    end

    context 'with scope as a proc' do
      subject { Post.after('2014-01-05', field: 'created_at', scope: ->{ where(day_of_month: 5) }) }
      it { expect(subject.count).to eql(1) }
    end
  end

  describe '#oldest and #newest' do

    context 'point-in-time' do
      it { expect(Post.newest.created_at).to eq Time.zone.parse('2014-04-15 17:00:00') }
      it { expect(Post.oldest.created_at).to eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'timespan' do
      it { expect(Event.newest.created_at).to eq Time.zone.parse('2014-04-15 17:00:00') }
      it { expect(Event.oldest.created_at).to eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'timespan strict' do
      it { expect(Event.newest(strict: true).created_at).to eq Time.zone.parse('2014-04-15 17:00:00') }
      it { expect(Event.oldest(strict: true).created_at).to eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'alternative field' do
      it { expect(Event.newest(field: 'created_at').created_at).to eq Time.zone.parse('2014-04-15 17:00:00') }
      it { expect(Event.oldest(field: 'created_at').created_at).to eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'with default scope' do
      it { expect(Appointment.newest(field: 'created_at').created_at).to eq Time.zone.parse('2014-04-01 17:00:00') }
      it { expect(Appointment.oldest(field: 'created_at').created_at).to eq Time.zone.parse('2013-11-01 17:00:00') }
    end

    context 'with scope as a query criteria' do
      it { expect(Post.newest(field: 'created_at', scope: Post.where(day_of_month: 5)).created_at).to eq Time.zone.parse('2014-01-05 17:00:00') }
      it { expect(Post.oldest(field: 'created_at', scope: Post.where(day_of_month: 5)).created_at).to eq Time.zone.parse('2013-12-05 17:00:00') }
    end

    context 'with scope as a proc' do
      it { expect(Post.newest(field: 'created_at', scope: ->{ where(day_of_month: 5) }).created_at).to eq Time.zone.parse('2014-01-05 17:00:00') }
      it { expect(Post.oldest(field: 'created_at', scope: ->{ where(day_of_month: 5) }).created_at).to eq Time.zone.parse('2013-12-05 17:00:00') }
    end
  end

  describe '#previous and #next' do

    context 'point-in-time' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-10 17:00:00')).first }
      it{ expect(subject.previous.created_at).to eq Time.zone.parse('2014-01-05 17:00:00') }
      it{ expect(subject.next.created_at).to eq Time.zone.parse('2014-01-12 17:00:00') }
    end

    context 'timespan' do
      subject { Event.where(start_time: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ expect(subject.previous.start_time).to eq Time.zone.parse('2013-12-31 17:00:00') }
      it{ expect(subject.next.start_time).to eq Time.zone.parse('2014-01-07 17:00:00') }
    end

    context 'with default scope' do
      subject { Appointment.where(created_at: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ expect(subject.previous.created_at).to eq Time.zone.parse('2014-01-01 17:00:00') }
      it{ expect(subject.next.created_at).to eq Time.zone.parse('2014-02-01 17:00:00') }
    end

    context 'with scope as a query criteria' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ expect(subject.previous({ scope: Post.where(day_of_month: 5) }).created_at).to eq Time.zone.parse('2013-12-05 17:00:00')  }
      it{ expect(subject.next({ scope: Post.where(day_of_month: 1) }).created_at).to eq Time.zone.parse('2014-02-01 17:00:00')  }
    end

    context 'with scope as a proc' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-05 17:00:00')).first }
      it{ expect(subject.previous({ scope: Proc.new{ where(day_of_month: 5) } }).created_at).to eq Time.zone.parse('2013-12-05 17:00:00') }
      it{ expect(subject.previous({ scope: Proc.new{|record| where(day_of_month: record.day_of_month) } }).created_at).to eq Time.zone.parse('2013-12-05 17:00:00') }
      it{ expect(subject.next({ scope: ->{ where(day_of_month: 1) } }).created_at).to eq Time.zone.parse('2014-02-01 17:00:00') }
      it{ expect(subject.next({ scope: ->(record){ where(day_of_month: record.day_of_month - 4) } }).created_at).to eq Time.zone.parse('2014-02-01 17:00:00') }
    end

    context 'specify a field' do
      subject { Post.where(created_at: Time.zone.parse('2014-01-01 17:00:00')).first }
      it{ expect(subject.previous.created_at).to eq Time.zone.parse('2013-12-31 17:00:00') }
      it{ expect(subject.next.created_at).to eq Time.zone.parse('2014-01-05 17:00:00') }
      it{ expect(subject.previous(field: 'updated_at').created_at).to eq Time.zone.parse('2013-12-31 17:00:00') }
      it{ expect(subject.next(field: 'updated_at').created_at).to eq Time.zone.parse('2014-01-01 17:00:00') }
    end

  end
end
