require 'spec_helper'

shared_examples_for 'by calendar month' do

  describe '#by_calendar_month' do

    context 'point-in-time' do
      subject { Post.by_calendar_month('Feb') }
      its(:count){ should eq 3 }
    end

    context 'timespan' do
      subject { Event.by_calendar_month(1) }
      its(:count){ should eq 10 }
    end

    context 'timespan strict' do
      subject { Event.by_calendar_month(Date.parse('2014-02-01'), strict: true) }
      its(:count){ should eq 2 }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_calendar_month(12, year: 2013) }
        its(:count){ should eq 12 }
      end

      context 'timespan' do
        subject { Event.by_calendar_month('December', year: 2013) }
        its(:count){ should eq 13 }
      end

      context 'timespan strict' do
        subject { Event.by_calendar_month('Dec', year: 2013, strict: true) }
        its(:count){ should eq 9 }
      end
    end

    it 'should raise an error when given an invalid argument' do
      ->{ Post.by_calendar_month(0) }.should raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
      ->{ Post.by_calendar_month(13) }.should raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
      ->{ Post.by_calendar_month('foobar') }.should raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name')
    end

    it 'should be able to use an alternative field' do
      Event.by_calendar_month(:field => 'end_time').count.should eq 9
    end

    context ':start_day option' do
      subject { Post.by_calendar_month(1, :start_day => :wednesday) }
      its(:count){ should eq 7 }
    end
  end
end
