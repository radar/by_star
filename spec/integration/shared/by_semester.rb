require 'spec_helper'

shared_examples_for 'by semester' do

  describe '#by_semester' do

    context 'point-in-time' do
      subject { Post.by_semester(1) }
      it { expect(subject.count).to eql(12) }
    end

    context 'timespan' do
      subject { Event.by_semester(1) }
      it { expect(subject.count).to eql(14) }
    end

    context 'timespan strict' do
      subject { Event.by_semester(Date.parse('2014-02-01'), strict: true) }
      it { expect(subject.count).to eql(9) }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_semester(2, year: 2013) }
        it { expect(subject.count).to eql(10) }
      end

      context 'timespan' do
        subject { Event.by_semester(2, year: 2013) }
        it { expect(subject.count).to eql(13) }
      end

      context 'timespan strict' do
        subject { Event.by_semester(2, year: 2013, strict: true) }
        it { expect(subject.count).to eql(8) }
      end
    end

    it 'should raise an error when given an invalid argument' do
      expect{ Post.by_semester(0) }.to raise_error(ByStar::ParseError, 'Semester number must be between 1 and 2')
      expect{ Post.by_semester(5) }.to raise_error(ByStar::ParseError, 'Semester number must be between 1 and 2')
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_semester(1, field: 'end_time').count).to eq(14)
    end
  end
end
