require 'spec_helper'

describe Date do

  describe '#in_time_zone' do

    subject { Date.new }

    before do
      stub_const('Date', Class.new)
      allow_any_instance_of(Date).to receive(:to_time_in_current_zone)
    end

    context 'when #in_time_zone is already defined' do
      before do
        expect_any_instance_of(Date).to receive(:in_time_zone)
      end

      context 'when ByStar::Kernel::InTimeZone included' do
        before do
          ::Date.__send__(:include, ByStar::Kernel::InTimeZone)
        end

        it 'should not be aliased to #to_time_in_current_zone' do
          expect(subject).not_to receive(:to_time_in_current_zone)
          subject.in_time_zone
        end
      end

      context 'when ByStar::Kernel::InTimeZone not included' do

        it 'should not be aliased to #to_time_in_current_zone' do
          expect(subject).not_to receive(:to_time_in_current_zone)
          subject.in_time_zone
        end
      end
    end

    context 'when #in_time_zone is not defined' do

      context 'when ByStar::Kernel::InTimeZone included' do
        before do
          ::Date.__send__(:include, ByStar::Kernel::InTimeZone)
        end

        it 'should be aliased to #to_time_in_current_zone' do
          expect(subject).to receive(:to_time_in_current_zone)
          subject.in_time_zone
        end
      end

      context 'when ByStar::Kernel::InTimeZone not included' do

        it 'should raise NoMethodError' do
          expect{ subject.in_time_zone }.to raise_error(NoMethodError)
        end
      end
    end
  end

  describe 'weekend' do

    (0..6).each do |n|
      context "Monday plus #{n} days" do
        subject { Date.parse('2014-01-06') + n.days }
        it { expect(subject.beginning_of_weekend).to eq Date.parse('2014-01-11') }
        it { expect(subject.end_of_weekend).to eq Date.parse('2014-01-12') }
      end
    end
  end

  describe 'fortnight' do

    context 'first day of year' do
      subject { Date.parse '2014-01-01' }
      it { expect(subject.beginning_of_fortnight).to eq Date.parse('2014-01-01') }
      it { expect(subject.end_of_fortnight).to eq Date.parse('2014-01-14') }
    end

    context 'second fortnight of year' do
      subject { Date.parse '2014-01-16' }
      it { expect(subject.beginning_of_fortnight).to eq Date.parse('2014-01-15') }
      it { expect(subject.end_of_fortnight).to eq Date.parse('2014-01-28') }
    end

    context 'middle of year' do
      subject { Date.parse '2014-06-13' }
      it { expect(subject.beginning_of_fortnight).to eq Date.parse('2014-06-04') }
      it { expect(subject.end_of_fortnight).to eq Date.parse('2014-06-17') }
    end

    context 'last day of year' do
      subject { Date.parse '2014-12-31' }
      it { expect(subject.beginning_of_fortnight).to eq Date.parse('2014-12-31') }
      it { expect(subject.end_of_fortnight).to eq Date.parse('2015-01-13') }
    end
  end

  describe 'calendar_month' do

    subject { Date.parse '2014-01-01' }

    context 'week begins Monday' do
      it { expect(subject.beginning_of_calendar_month).to eq Date.parse('2013-12-30') }
      it { expect(subject.end_of_calendar_month).to eq Date.parse('2014-02-02') }
    end

    context 'week begins Sunday' do
      it { expect(subject.beginning_of_calendar_month(:sunday)).to eq Date.parse('2013-12-29') }
      it { expect(subject.end_of_calendar_month(:sunday)).to eq Date.parse('2014-02-01') }
    end
  end
end
