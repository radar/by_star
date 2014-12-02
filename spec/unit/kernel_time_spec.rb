require 'spec_helper'

describe Time do

  describe 'weekend' do

    (0..6).each do |n|
      context "Monday plus #{n} days" do
        subject { Time.zone.parse('2014-01-06') + n.days }
        it { expect(subject.beginning_of_weekend).to eq Time.zone.parse('2014-01-10 15:00') }
        it { expect(subject.end_of_weekend).to eq Time.zone.parse('2014-01-13 02:00').end_of_hour }
      end
    end
  end

  describe 'fortnight' do

    context 'first day of year' do
      subject { Time.zone.parse '2014-01-01' }
      it { expect(subject.beginning_of_fortnight).to eq Time.zone.parse('2014-01-01') }
      it { expect(subject.end_of_fortnight).to eq Time.zone.parse('2014-01-14').end_of_day }
    end

    context 'second fortnight of year' do
      subject { Time.zone.parse '2014-01-16' }
      it { expect(subject.beginning_of_fortnight).to eq Time.zone.parse('2014-01-15') }
      it { expect(subject.end_of_fortnight).to eq Time.zone.parse('2014-01-28').end_of_day }
    end

    context 'middle of year' do
      subject { Time.zone.parse '2014-06-13' }
      it { expect(subject.beginning_of_fortnight).to eq Time.zone.parse('2014-06-04') }
      it { expect(subject.end_of_fortnight).to eq Time.zone.parse('2014-06-17').end_of_day }
    end

    context 'last day of year' do
      subject { Time.zone.parse '2014-12-31' }
      it { expect(subject.beginning_of_fortnight).to eq Time.zone.parse('2014-12-31') }
      it { expect(subject.end_of_fortnight).to eq Time.zone.parse('2015-01-13').end_of_day }
    end
  end

  describe 'calendar_month' do

    subject { Time.zone.parse '2014-01-01' }

    context 'week begins Monday' do
      it { expect(subject.beginning_of_calendar_month).to eq Time.zone.parse('2013-12-30') }
      it { expect(subject.end_of_calendar_month).to eq Time.zone.parse('2014-02-02').end_of_day }
    end

    context 'week begins Sunday' do
      it { expect(subject.beginning_of_calendar_month(:sunday)).to eq Time.zone.parse('2013-12-29') }
      it { expect(subject.end_of_calendar_month(:sunday)).to eq Time.zone.parse('2014-02-01').end_of_day }
    end
  end
end
