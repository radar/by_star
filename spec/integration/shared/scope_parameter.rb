require 'spec_helper'

shared_examples_for 'scope parameter' do

  describe 'scope' do
    it 'should memoize the scope variable' do
      expect(Event.instance_variable_get(:@by_star_scope)).to be_nil
      expect(Post.instance_variable_get(:@by_star_scope)).to be_nil
      expect(Appointment.instance_variable_get(:@by_star_scope)).to be_a Proc
    end

    context 'between_times with default scope' do
      subject { Appointment.between_times(Date.parse('2013-12-01'), Date.parse('2014-02-01')) }
      it { expect(subject.count).to eql(3) }
    end

    context 'between_times with scope override as a query criteria' do
      subject { Appointment.between_times(Date.parse('2013-12-01')..Date.parse('2014-02-01'), scope: Appointment.unscoped) }
      it { expect(subject.count).to eql(14) }
    end

    context 'between_times with scope override as a Lambda' do
      subject { Appointment.between_times(Date.parse('2013-12-01'), Date.parse('2014-02-01'), scope: ->{ unscoped }) }
      it { expect(subject.count).to eql(14) }
    end

    context 'between_times with scope override as a Lambda' do
      subject { Appointment.between_times(Date.parse('2013-12-01')..Date.parse('2014-02-01'), scope: ->(x){ unscoped }) }
      it{ expect{ subject }.to raise_error(RuntimeError, 'ByStar :scope Proc requires :scope_args to be specified.') }
    end

    context 'between_times with scope override as a Proc with arguments' do
      subject { Appointment.between_times(Date.parse('2013-12-01'), Date.parse('2014-02-01'), scope: Proc.new{ unscoped }) }
      it { expect(subject.count).to eql(14) }
    end

    context 'between_times with scope override as a Proc with arguments' do
      subject { Appointment.between_times(Date.parse('2013-12-01')..Date.parse('2014-02-01'), scope: Proc.new{|x,y| unscoped }) }
      it{ expect{ subject }.to raise_error(RuntimeError, 'ByStar :scope Proc requires :scope_args to be specified.') }
    end

    context 'by_month with default scope' do
      subject { Appointment.by_month(Date.parse('2014-01-01')) }
      it { expect(subject.count).to eql(2) }
    end

    context 'by_month with scope override as a query criteria' do
      subject { Appointment.by_month(Date.parse('2014-01-01'), scope: Appointment.unscoped) }
      it { expect(subject.count).to eql(6) }
    end

    context 'by_month with scope override as a Lambda' do
      subject { Appointment.by_month(Date.parse('2014-01-01'), scope: ->{ unscoped }) }
      it { expect(subject.count).to eql(6) }
    end

    context 'by_month with scope override as a Lambda with arguments' do
      subject { Appointment.by_month(Date.parse('2014-01-01'), scope: ->(x){ unscoped }) }
      it{ expect{ subject }.to raise_error(RuntimeError, 'ByStar :scope Proc requires :scope_args to be specified.') }
    end

    context 'by_month with scope override as a Proc' do
      subject { Appointment.by_month(Date.parse('2014-01-01'), scope: Proc.new{ unscoped }) }
      it { expect(subject.count).to eql(6) }
    end

    context 'by_month with scope override as a Proc with arguments' do
      subject { Appointment.by_month(Date.parse('2014-01-01'), scope: Proc.new{|x| unscoped }) }
      it{ expect{ subject }.to raise_error(RuntimeError, 'ByStar :scope Proc requires :scope_args to be specified.') }
    end
  end
end
