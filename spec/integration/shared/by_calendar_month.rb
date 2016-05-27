require 'spec_helper'

shared_examples_for 'by calendar month' do

  describe '#by_calendar_month' do

    context 'point-in-time' do
      subject { Post.by_calendar_month('Feb') }
      it { expect(subject.count).to eql(3) }
    end

    context 'timespan' do
      subject { Event.by_calendar_month(1) }
      it { expect(subject.count).to eql(10) }
    end

    context 'timespan strict' do
      subject { Event.by_calendar_month(Date.parse('2014-02-01'), strict: true) }
      it { expect(subject.count).to eql(2) }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_calendar_month(12, year: 2013) }
        it { expect(subject.count).to eql(12) }
      end

      context 'timespan' do
        subject { Event.by_calendar_month('December', year: 2013) }
        it { expect(subject.count).to eql(13) }
      end

      context 'timespan strict' do
        subject { Event.by_calendar_month('Dec', year: 2013, strict: true) }
        it { expect(subject.count).to eql(9) }
      end
    end

    it 'should raise an error when given an invalid argument' do
      expect{ Post.by_calendar_month(0) }.to raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
      expect{ Post.by_calendar_month(13) }.to raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
      expect{ Post.by_calendar_month('foobar') }.to raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_calendar_month(field: 'end_time').count).to eql(9)
    end

    context ':start_day option' do
      subject { Post.by_calendar_month(1, start_day: :wednesday) }
      it{ expect(subject.count).to eql(7) }
    end
  end
end
