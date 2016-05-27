require 'spec_helper'

shared_examples_for 'by year' do

  describe '#by_year' do

    context 'point-in-time' do
      subject { Post.by_year('2014') }
      it { expect(subject.count).to eql(12) }
    end

    context 'timespan' do
      subject { Event.by_year(13) }
      it { expect(subject.count).to eql(13) }
    end

    context 'timespan strict' do
      subject { Event.by_year(Date.parse('2014-02-01'), strict: true) }
      it { expect(subject.count).to eql(9) }
    end

    context 'integer' do

      context 'point-in-time' do
        subject { Post.by_year(2013) }
        it { expect(subject.count).to eql(10) }
      end

      context 'timespan' do
        subject { Event.by_year(2014) }
        it { expect(subject.count).to eql(14) }
      end

      context 'timespan strict' do
        subject { Event.by_year(2013, strict: true) }
        it { expect(subject.count).to eql(8) }
      end
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_year(:field => 'end_time').count).to eq 14
    end

    it 'can use a 2-digit year' do
      expect(Post.by_year(13).count).to eq 10
    end
  end
end
