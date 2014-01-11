require 'spec_helper'

describe Time do

  describe 'weekend' do

    (0..6).each do |n|
      context "Monday plus #{n} days" do
        subject { Time.parse('2014-01-06') + n.days }
        its(:beginning_of_weekend){ should eq Time.parse('2014-01-10 15:00') }
        its(:end_of_weekend){ should eq Time.parse('2014-01-13 02:00').end_of_hour }
      end
    end
  end

  describe 'fortnight' do

    context 'first day of year' do
      subject { Time.parse '2014-01-01' }
      its(:beginning_of_fortnight){ should eq Time.parse('2014-01-01') }
      its(:end_of_fortnight){ should eq Time.parse('2014-01-14').end_of_day }
    end

    context 'second fortnight of year' do
      subject { Time.parse '2014-01-16' }
      its(:beginning_of_fortnight){ should eq Time.parse('2014-01-15') }
      its(:end_of_fortnight){ should eq Time.parse('2014-01-28').end_of_day }
    end

    context 'middle of year' do
      subject { Time.parse '2014-06-13' }
      its(:beginning_of_fortnight){ should eq Time.parse('2014-06-04') }
      its(:end_of_fortnight){ should eq Time.parse('2014-06-17').end_of_day }
    end

    context 'last day of year' do
      subject { Time.parse '2014-12-31' }
      its(:beginning_of_fortnight){ should eq Time.parse('2014-12-31') }
      its(:end_of_fortnight){ should eq Time.parse('2015-01-13').end_of_day }
    end
  end

  describe 'calendar_month' do

    subject { Time.parse '2014-01-01' }

    context 'week begins Monday' do
      its(:beginning_of_calendar_month){ should eq Time.parse('2013-12-30') }
      its(:end_of_calendar_month){ should eq Time.parse('2014-02-02').end_of_day }
    end

    context 'week begins Sunday' do
      it { subject.beginning_of_calendar_month(:sunday).should eq Time.parse('2013-12-29') }
      it { subject.end_of_calendar_month(:sunday).should eq Time.parse('2014-02-01').end_of_day }
    end
  end
end
