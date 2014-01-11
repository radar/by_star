require 'spec_helper'

shared_examples_for 'by week' do

  describe '#by_week' do

    context 'point-in-time' do
      subject { Post.by_week('2014-01-02') }
      its(:count){ should eq 4 }
    end

    context 'timespan' do
      subject { Event.by_week(0) }
      its(:count){ should eq 5 }
    end

    context 'timespan strict' do
      subject { Event.by_week(Date.parse('2014-01-01'), strict: true) }
      its(:count){ should eq 0 }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_week(52, year: 2013) }
        its(:count){ should eq 4 }
      end

      context 'timespan' do
        subject { Event.by_week(52, year: 2013) }
        its(:count){ should eq 5 }
      end

      context 'timespan strict' do
        subject { Event.by_week(52, year: 2013, strict: true) }
        its(:count){ should eq 0 }
      end
    end

    it 'should raise an error when given an invalid argument' do
      lambda { Post.by_weekend(-1) }.should raise_error(ByStar::ParseError, 'Week number must be between 0 and 52')
      lambda { Post.by_weekend(53) }.should raise_error(ByStar::ParseError, 'Week number must be between 0 and 52')
    end

    it 'should be able to use an alternative field' do
      Event.by_week(:field => 'end_time').count.should eq 5
    end

    context ':start_day option' do
      subject { Post.by_week('2014-01-02', :start_day => :thursday) }
      its(:count){ should eq 1 }
    end
  end
end
