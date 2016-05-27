require 'spec_helper'

shared_examples_for 'by day' do

  describe '#by_day' do

    context 'point-in-time' do
      it { expect(Post.by_day('2014-01-01').count).to eql(2) }
    end

    context 'timespan' do
      it { expect(Event.by_day(Time.zone.parse '2014-01-01').count).to eql(5) }
    end

    context 'timespan strict' do
      it { expect(Event.by_day(Date.parse('2014-01-01'), strict: true).count).to eql(0) }
    end

    it 'should be able to use an alternative field' do
      expect(Event.by_day(field: 'end_time').count).to eql(0)
    end

    it 'should support :offset option' do
      expect(Post.by_day('2014-01-01', offset: -16.hours).count).to eq(1)
    end
  end

  describe '#today' do # 2014-01-01

    context 'point-in-time' do
      it { expect(Post.today.count).to eql(2) }
    end

    context 'timespan' do
      it { expect(Event.today.count).to eql(5) }
    end

    context 'timespan strict' do
      it { expect(Event.today(strict: true).count).to eql(0) }
    end

    it 'should be able to use an alternative field' do
      expect(Event.today(field: 'created_at').count).to eql(2)
    end

    it 'should support :offset option' do
      expect(Post.today(offset: -24.hours).count).to eql(1)
    end
  end

  describe '#yesterday' do # 2013-12-31

    context 'point-in-time' do
      it { expect(Post.yesterday.count).to eql(1) }
    end

    context 'timespan' do
      it { expect(Event.yesterday.count).to eql(5) }
    end

    context 'timespan strict' do
      it { expect(Event.yesterday(strict: true).count).to eql(0) }
    end

    it 'should be able to use an alternative field' do
      expect(Event.yesterday(field: 'created_at').count).to eql(1)
    end

    it 'should support :offset option' do
      expect(Post.yesterday(offset: 24.hours).count).to eql(2)
    end
  end

  describe '#tomorrow' do # 2014-01-02

    context 'point-in-time' do
      it { expect(Post.tomorrow.count).to eql(0) }
    end

    context 'timespan' do
      it { expect(Event.tomorrow.count).to eql(5) }
    end

    context 'timespan strict' do
      it { expect(Event.tomorrow(strict: true).count).to eql(0) }
    end

    it 'should be able to use an alternative field' do
      expect(Event.tomorrow(field: 'created_at').count).to eql(0)
    end

    it 'should support :offset option' do
      expect(Post.tomorrow(offset: -24.hours).count).to eql(2)
    end
  end
end
