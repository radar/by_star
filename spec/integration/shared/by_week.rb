require 'spec_helper'

shared_examples_for 'by week' do

  describe '#by_week' do

    context 'point-in-time' do
      subject { Post.by_week('2014-01-02') }
      it { expect(subject.count).to eql(4) }
    end

    context 'timespan' do
      subject { Event.by_week(0) }
      it { expect(subject.count).to eql(7) }
    end

    context 'timespan strict' do
      subject { Event.by_week(Date.parse('2014-01-01'), strict: true) }
      it { expect(subject.count).to eql(0) }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_week(52, year: 2013) }
        it { expect(subject.count).to eql(4) }
      end

      context 'timespan' do
        subject { Event.by_week(52, year: 2013) }
        it { expect(subject.count).to eql(7) }
      end

      context 'timespan strict' do
        subject { Event.by_week(52, year: 2013, strict: true) }
        it { expect(subject.count).to eql(0) }
      end
    end

    it 'should raise an error when given an invalid argument' do
      expect { Post.by_week(-1) }.to raise_error(ByStar::ParseError, 'Week number must be between 0 and 52')
      expect { Post.by_week(53) }.to raise_error(ByStar::ParseError, 'Week number must be between 0 and 52')
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_week(field: 'end_time').count).to eq 3
    end

    context ':start_day option' do
      subject { Post.by_week('2014-01-02', start_day: :thursday) }
      it { expect(subject.count).to eql(1) }
    end
  end
end
