require 'spec_helper'

shared_examples_for 'scope parameter' do

  describe ':scope' do
    context 'between_times with default scope' do
      subject { Appointment.between_times(Date.parse('2013-12-01')..Date.parse('2014-02-01')) }
      it { expect(subject.count).to eql(14) }
    end

    context 'by_month with default scope' do
      subject { Appointment.by_month(Date.parse('2014-01-01')) }
      it { expect(subject.count).to eql(6) }
    end
  end
end
