require 'spec_helper'

shared_examples_for 'by quarter' do

  describe '#by_quarter' do

    context 'point-in-time' do
      subject { Post.by_quarter(2) }
      its(:count){ should eq 2 }
    end

    context 'timespan' do
      subject { Event.by_quarter(1) }
      its(:count){ should eq 12 }
    end

    context 'timespan strict' do
      subject { Event.by_quarter(Date.parse('2014-02-01'), strict: true) }
      its(:count){ should eq 7 }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_quarter(4, year: 2013) }
        its(:count){ should eq 1 }
      end

      context 'timespan' do
        subject { Event.by_quarter(4, year: 2013) }
        its(:count){ should eq 4 }
      end

      context 'timespan strict' do
        subject { Event.by_quarter(4, year: 2013, strict: true) }
        its(:count){ should eq 0 }
      end
    end

    it 'should raise an error when given an invalid argument' do
      ->{ Post.by_quarter(0) }.should raise_error(ByStar::ParseError, 'Quarter number must be between 1 and 4')
      ->{ Post.by_quarter(5) }.should raise_error(ByStar::ParseError, 'Quarter number must be between 1 and 4')
    end

    it 'should be able to use an alternative field' do
      Event.by_quarter(1, :field => 'end_time').count.should eq 12
    end
  end
end
