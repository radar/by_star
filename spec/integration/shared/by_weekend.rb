require 'spec_helper'

shared_examples_for 'by weekend' do

  describe '#by_weekend' do

    context 'point-in-time' do
      subject { Post.by_weekend('2014-01-01') }
      it { expect(subject.count).to eql(1) }
    end

    context 'timespan' do
      subject { Event.by_weekend(0) }
      it { expect(subject.count).to eql(5) }
    end

    context 'timespan strict' do
      subject { Event.by_weekend(Date.parse('2014-01-01'), strict: true) }
      it { expect(subject.count).to eql(0) }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_weekend(52, year: 2013) }
        it { expect(subject.count).to eql(1) }
      end

      context 'timespan' do
        subject { Event.by_weekend(52, year: 2013) }
        it { expect(subject.count).to eql(5) }
      end

      context 'timespan strict' do
        subject { Event.by_weekend(52, year: 2013, strict: true) }
        it { expect(subject.count).to eql(0) }
      end
    end

    it 'should raise an error when given an invalid argument' do
      expect { Post.by_weekend(-1) }.to raise_error(ByStar::ParseError, 'Week number must be between 0 and 52')
      expect { Post.by_weekend(53) }.to raise_error(ByStar::ParseError, 'Week number must be between 0 and 52')
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_weekend(field: 'end_time').count).to eq 1
    end
  end
end
