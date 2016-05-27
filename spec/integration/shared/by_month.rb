require 'spec_helper'

shared_examples_for 'by month' do

  describe '#by_month' do

    context 'point-in-time' do
      subject { Post.by_month('Feb') }
      it { expect(subject.count).to eql(2) }
    end

    context 'timespan' do
      subject { Event.by_month(1) }
      it { expect(subject.count).to eql(9) }
    end

    context 'timespan strict' do
      subject { Event.by_month(Date.parse('2014-02-01'), strict: true) }
      it { expect(subject.count).to eql(1) }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_month(12, year: 2013) }
        it { expect(subject.count).to eql(8) }
      end

      context 'timespan' do
        subject { Event.by_month('December', year: 2013) }
        it { expect(subject.count).to eql(12) }
      end

      context 'timespan strict' do
        subject { Event.by_month('Dec', year: 2013, strict: true) }
        it { expect(subject.count).to eql(4) }
      end
    end

    it 'should raise an error when given an invalid argument' do
      expect{ Post.by_month(0) }.to raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
      expect{ Post.by_month(13) }.to raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
      expect{ Post.by_month('foobar') }.to raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_month(field: 'end_time').count).to eq 8
    end
  end
end
