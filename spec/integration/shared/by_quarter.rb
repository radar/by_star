require 'spec_helper'

shared_examples_for 'by quarter' do

  describe '#by_quarter' do

    context 'point-in-time' do
      subject { Post.by_quarter(2) }
      it { expect(subject.count).to eql(2) }
    end

    context 'timespan' do
      subject { Event.by_quarter(1) }
      it { expect(subject.count).to eql(13) }
    end

    context 'timespan strict' do
      subject { Event.by_quarter(Date.parse('2014-02-01'), strict: true) }
      it { expect(subject.count).to eql(7) }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_quarter(4, year: 2013) }
        it { expect(subject.count).to eql(10) }
      end

      context 'timespan' do
        subject { Event.by_quarter(4, year: 2013) }
        it { expect(subject.count).to eql(13) }
      end

      context 'timespan strict' do
        subject { Event.by_quarter(4, year: 2013, strict: true) }
        it { expect(subject.count).to eql(8) }
      end
    end

    it 'should raise an error when given an invalid argument' do
      expect{ Post.by_quarter(0) }.to raise_error(ByStar::ParseError, 'Quarter number must be between 1 and 4')
      expect{ Post.by_quarter(5) }.to raise_error(ByStar::ParseError, 'Quarter number must be between 1 and 4')
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_quarter(1, field: 'end_time').count).to eq 12
    end
  end
end
