require 'spec_helper'

shared_examples_for 'relative' do

  describe '#past_day' do
    context 'point-in-time' do
      subject { Post.past_day }
      it { expect(subject.count).to eql(1) }
    end

    context 'timespan' do
      subject { Event.past_day }
      it { expect(subject.count).to eql(5) }
    end

    context 'timespan strict' do
      subject { Event.past_day(strict: true) }
      it { expect(subject.count).to eql(0) }
    end
  end

  describe '#past_week' do
    context 'point-in-time' do
      subject { Post.past_week }
      it { expect(subject.count).to eql(3) }
    end

    context 'timespan' do
      subject { Event.past_week }
      it { expect(subject.count).to eql(7) }
    end

    context 'timespan strict' do
      subject { Event.past_week(strict: true) }
      it { expect(subject.count).to eql(0) }
    end
  end

  describe '#past_fortnight' do
    context 'point-in-time' do
      subject { Post.past_fortnight }
      it { expect(subject.count).to eql(4) }
    end

    context 'timespan' do
      subject { Event.past_fortnight }
      it { expect(subject.count).to eql(8) }
    end

    context 'timespan strict' do
      subject { Event.past_fortnight(strict: true) }
      it { expect(subject.count).to eql(1) }
    end
  end

  describe '#past_month' do
    context 'point-in-time' do
      subject { Post.past_month }
      it { expect(subject.count).to eql(8) }
    end

    context 'timespan' do
      subject { Event.past_month }
      it { expect(subject.count).to eql(12) }
    end

    context 'timespan strict' do
      subject { Event.past_month(strict: true) }
      it { expect(subject.count).to eql(4) }
    end
  end

  describe '#past_year' do
    context 'point-in-time' do
      subject { Post.past_year }
      it { expect(subject.count).to eql(10) }
    end

    context 'timespan' do
      subject { Event.past_year }
      it { expect(subject.count).to eql(13) }
    end

    context 'timespan strict' do
      subject { Event.past_year(strict: true) }
      it { expect(subject.count).to eql(8) }
    end
  end

  describe '#next_day' do
    context 'point-in-time' do
      subject { Post.next_day }
      it { expect(subject.count).to eql(2) }
    end

    context 'timespan' do
      subject { Event.next_day }
      it { expect(subject.count).to eql(5) }
    end

    context 'timespan strict' do
      subject { Event.next_day(strict: true) }
      it { expect(subject.count).to eql(0) }
    end
  end

  describe '#next_week' do
    context 'point-in-time' do
      subject { Post.next_week }
      it { expect(subject.count).to eql(3) }
    end

    context 'timespan' do
      subject { Event.next_week }
      it { expect(subject.count).to eql(7) }
    end

    context 'timespan strict' do
      subject { Event.next_week(strict: true) }
      it { expect(subject.count).to eql(0) }
    end
  end

  describe '#next_fortnight' do
    context 'point-in-time' do
      subject { Post.next_fortnight }
      it { expect(subject.count).to eql(5) }
    end

    context 'timespan' do
      subject { Event.next_fortnight }
      it { expect(subject.count).to eql(7) }
    end

    context 'timespan strict' do
      subject { Event.next_fortnight(strict: true) }
      it { expect(subject.count).to eql(0) }
    end
  end

  describe '#next_month' do
    context 'point-in-time' do
      subject { Post.next_month }
      it { expect(subject.count).to eql(6) }
    end

    context 'timespan' do
      subject { Event.next_month }
      it { expect(subject.count).to eql(9) }
    end

    context 'timespan strict' do
      subject { Event.next_month(strict: true) }
      it { expect(subject.count).to eql(3) }
    end
  end

  describe '#next_year' do
    context 'point-in-time' do
      subject { Post.next_year }
      it { expect(subject.count).to eql(12) }
    end

    context 'timespan' do
      subject { Event.next_year }
      it { expect(subject.count).to eql(14) }
    end

    context 'timespan strict' do
      subject { Event.next_year(strict: true) }
      it { expect(subject.count).to eql(9) }
    end
  end
end
