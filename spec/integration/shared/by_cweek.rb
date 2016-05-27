require 'spec_helper'

shared_examples_for 'by cweek' do

  describe '#by_cweek' do

    context 'point-in-time' do
      subject { Post.by_cweek('2014-01-02') }
      it { expect(subject.count).to eql(4) }
    end

    context 'timespan' do
      subject { Event.by_cweek(1) }
      it { expect(subject.count).to eql(7) }
    end

    context 'timespan strict' do
      subject { Event.by_cweek(Date.parse('2014-01-01'), strict: true) }
      it { expect(subject.count).to eql(0) }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_cweek(53, year: 2013) }
        it { expect(subject.count).to eql(4) }
      end

      context 'timespan' do
        subject { Event.by_cweek(53, year: 2013) }
        it { expect(subject.count).to eql(7) }
      end

      context 'timespan strict' do
        subject { Event.by_cweek(53, year: 2013, strict: true) }
        it { expect(subject.count).to eql(0) }
      end
    end

    it 'should raise an error when given an invalid argument' do
      expect { Post.by_cweek(0) }.to raise_error(ByStar::ParseError, 'cweek number must be between 1 and 53')
      expect { Post.by_cweek(54) }.to raise_error(ByStar::ParseError, 'cweek number must be between 1 and 53')
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_cweek(field: 'end_time').count).to eq 3
    end

    context ':start_day option' do
      subject { Post.by_cweek('2014-01-02', start_day: :thursday) }
      it { expect(subject.count).to eql(1) }
    end
  end
end
