require 'spec_helper'

shared_examples_for 'by year' do

  describe '#by_year' do

    context 'point-in-time' do
      subject { Post.by_year('2014') }
      its(:count){ should eq 12 }
    end

    context 'timespan' do
      subject { Event.by_year(13) }
      its(:count){ should eq 4 }
    end

    context 'timespan strict' do
      subject { Event.by_year(Date.parse('2014-02-01'), strict: true) }
      its(:count){ should eq 9 }
    end

    context 'with :year option' do

      context 'point-in-time' do
        subject { Post.by_year(year: 2013) }
        its(:count){ should eq 1 }
      end

      context 'timespan' do
        subject { Event.by_year(year: 2014) }
        its(:count){ should eq 13 }
      end

      context 'timespan strict' do
        subject { Event.by_year(year: 2013, strict: true) }
        its(:count){ should eq 0 }
      end
    end

    it 'should be able to use an alternative field' do
      Event.by_year(:field => 'end_time').count.should eq 13
    end

    it 'can use a 2-digit year' do
      Post.by_year(13).count.should eq 1
    end
  end
end
