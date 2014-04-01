require 'spec_helper'

shared_examples_for 'scope parameter' do

  describe 'scope' do
    it 'should memoize the scope variable' do
      Event.instance_variable_get(:@by_star_scope).should be_nil
      Post.instance_variable_get(:@by_star_scope).should be_nil
      Appointment.instance_variable_get(:@by_star_scope).should be_a Proc
    end

    context 'between_times with default scope' do
      subject { Appointment.between_times(Date.parse('2013-12-01'), Date.parse('2014-02-01')) }
      its(:count) { should eq 3 }
    end

    context 'between_times with scope override as a query criteria' do
      subject { Appointment.between_times(Date.parse('2013-12-01'), Date.parse('2014-02-01'), scope: Appointment.unscoped) }
      its(:count) { should eq 14 }
    end

    context 'between_times with scope override as a Proc' do
      subject { Appointment.between_times(Date.parse('2013-12-01'), Date.parse('2014-02-01'), scope: ->{ unscoped }) }
      its(:count) { should eq 14 }
    end

    context 'by_month with default scope' do
      subject { Appointment.by_month(Date.parse('2014-01-01')) }
      its(:count) { should eq 2 }
    end

    context 'by_month with scope override as a query criteria' do
      subject { Appointment.by_month(Date.parse('2014-01-01'), scope: Appointment.unscoped) }
      its(:count) { should eq 6 }
    end

    context 'by_month with scope override as a Proc' do
      subject { Appointment.by_month(Date.parse('2014-01-01'), scope: ->{ unscoped }) }
      its(:count) { should eq 6 }
    end
  end
end
