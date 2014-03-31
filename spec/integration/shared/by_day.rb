require 'spec_helper'

shared_examples_for 'by day' do

  describe '#by_day' do

    context 'point-in-time' do
      subject { Post.by_day('2014-01-01') }
      its(:count){ should eq 2 }
    end

    context 'timespan' do
      subject { Event.by_day(Time.parse '2014-01-01') }
      its(:count){ should eq 5 }
    end

    context 'timespan strict' do
      subject { Event.by_day(Date.parse('2014-01-01'), strict: true) }
      its(:count){ should eq 0 }
    end

    it 'should be able to use an alternative field' do
      Event.by_day(:field => 'end_time').count.should eq 0
    end

    it 'should support :offset option' do
      Post.by_day('2014-01-01', :offset => -16.hours).count.should eq 1
    end
  end

  describe '#today' do # 2014-01-01

    context 'point-in-time' do
      subject { Post.today }
      its(:count){ should eq 2 }
    end

    context 'timespan' do
      subject { Event.today }
      its(:count){ should eq 5 }
    end

    context 'timespan strict' do
      subject { Event.today(strict: true) }
      its(:count){ should eq 0 }
    end

    it 'should be able to use an alternative field' do
      Event.today(:field => 'created_at').count.should eq 2
    end

    it 'should support :offset option' do
      Post.today(:offset => -24.hours).count.should eq 1
    end
  end

  describe '#yesterday' do # 2013-12-31

    context 'point-in-time' do
      subject { Post.yesterday }
      its(:count){ should eq 1 }
    end

    context 'timespan' do
      subject { Event.yesterday }
      its(:count){ should eq 5 }
    end

    context 'timespan strict' do
      subject { Event.yesterday(strict: true) }
      its(:count){ should eq 0 }
    end

    it 'should be able to use an alternative field' do
      Event.yesterday(:field => 'created_at').count.should eq 1
    end

    it 'should support :offset option' do
      Post.yesterday(:offset => 24.hours).count.should eq 2
    end
  end

  describe '#tomorrow' do # 2014-01-02

    context 'point-in-time' do
      subject { Post.tomorrow }
      its(:count){ should eq 0 }
    end

    context 'timespan' do
      subject { Event.tomorrow }
      its(:count){ should eq 5 }
    end

    context 'timespan strict' do
      subject { Event.tomorrow(strict: true) }
      its(:count){ should eq 0 }
    end

    it 'should be able to use an alternative field' do
      Event.tomorrow(:field => 'created_at').count.should eq 0
    end

    it 'should support :offset option' do
      Post.tomorrow(:offset => -24.hours).count.should eq 2
    end
  end
end
