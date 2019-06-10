require 'spec_helper'

shared_examples_for 'index_scope parameter' do

  describe ':scope' do

    it 'should memoize the scope variable' do
      expect(Event.instance_variable_get(:@by_star_index_scope)).to be_nil
      expect(Post.instance_variable_get(:@by_star_index_scope)).to be_nil
      expect(Appointment.instance_variable_get(:@by_star_index_scope)).to be_a Proc
    end

    context 'between_times with index_scope' do

      context 'nil' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: nil) }
        it { expect(subject.count).to eql(16) }
      end

      context 'false' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: false) }
        it { expect(subject.count).to eql(16) }
      end

      context 'Time' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: Time.zone.parse('2013-11-30 17:00:00')) }
        it { expect(subject.count).to eql(14) }
      end

      context 'DateTime' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: Time.zone.parse('2013-11-30 17:00:00').to_datetime) }
        it { expect(subject.count).to eql(14) }
      end

      context 'Date' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: Date.parse('2013-11-30')) }
        it { expect(subject.count).to eql(14) }
      end

      context 'ActiveSupport::Duration' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: 3.hours) }
        it { expect(subject.count).to eql(13) }
      end

      context 'Numeric' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: 3600) }
        it { expect(subject.count).to eql(13) }
      end

      context ':beginning_of_day' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: :beginning_of_day) }
        it { expect(subject.count).to eql(13) }
      end

      context 'unsupported type' do
        subject { Event.between_times(Date.parse('2013-12-01'), Date.parse('2014-01-31'), index_scope: Integer) }
        it { expect{subject.count}.to raise_error(RuntimeError) }
      end
    end

    context 'at_time with index_scope' do

      context 'nil' do
        subject { Event.at_time(Time.zone.parse('2013-12-01 14:00'), index_scope: nil) }
        it { expect(subject.count).to eql(3) }
      end

      context 'false' do
        subject { Event.at_time(Time.zone.parse('2013-12-01 14:00'), index_scope: false) }
        it { expect(subject.count).to eql(3) }
      end

      context 'Time' do
        subject { Event.at_time(Time.zone.parse('2013-12-01 14:00'), index_scope: Time.zone.parse('2013-10-30 17:00:00')) }
        it { expect(subject.count).to eql(3) }
      end

      context 'DateTime' do
        subject { Event.at_time(Time.zone.parse('2013-12-01 14:00'), index_scope: Time.zone.parse('2013-11-30 17:00:00').to_datetime) }
        it { expect(subject.count).to eql(1) }
      end

      context 'Date' do
        subject { Event.at_time(Time.zone.parse('2013-12-01 14:00'), index_scope: Date.parse('2013-11-30')) }
        it { expect(subject.count).to eql(1) }
      end

      context 'ActiveSupport::Duration' do
        subject { Event.at_time(Time.zone.parse('2013-12-01 14:00'), index_scope: 100.hours) }
        it { expect(subject.count).to eql(1) }
      end

      context 'Numeric' do
        subject { Event.at_time(Time.zone.parse('2013-12-01 14:00'), index_scope: 60 * 60 * 1000) }
        it { expect(subject.count).to eql(3) }
      end

      context ':beginning_of_day' do
        let!(:custom_event){ t = Time.zone.parse('2013-12-30 17:00'); Event.create!(start_time: t - 1.hour, end_time: t + 1.hour) }
        subject { Event.at_time(Time.zone.parse('2013-12-30 16:00'), index_scope: :beginning_of_day) }
        it { expect(subject.count).to eql(1) }
        after { custom_event.delete }
      end

      context 'unsupported type' do
        subject { Event.at_time(Time.zone.parse('2013-12-01 14:00'), index_scope: Integer) }
        it { expect{subject.count}.to raise_error(RuntimeError) }
      end
    end
  end
end
