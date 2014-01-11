require 'spec_helper'

shared_examples_for 'by fortnight' do

  describe '#by_fortnight' do

    context 'point-in-time' do
      subject { Post.by_fortnight('2014-01-01') }
      its(:count){ should eq 5 }
    end

    context 'timespan' do
      subject { Event.by_fortnight(0) }
      its(:count){ should eq 6 }
    end

    context 'timespan strict' do
      subject { Event.by_fortnight(Date.parse('2014-01-01'), strict: true) }
      its(:count){ should eq 0 }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_fortnight(26, year: 2013) }
        its(:count){ should eq 6 }
      end

      context 'timespan' do
        subject { Event.by_fortnight(26, year: 2013) }
        its(:count){ should eq 6 }
      end

      context 'timespan strict' do
        subject { Event.by_fortnight(26, year: 2013, strict: true) }
        its(:count){ should eq 1 }
      end
    end

    it 'should raise an error when given an invalid argument' do
      lambda { Post.by_fortnight(27) }.should raise_error(ByStar::ParseError, 'Fortnight number must be between 0 and 26')
    end

    it 'should be able to use an alternative field' do
      Event.by_fortnight(:field => 'end_time').count.should eq 6
    end
  end
end
