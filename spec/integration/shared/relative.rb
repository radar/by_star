require 'spec_helper'

shared_examples_for 'relative' do

  describe '#past_day' do
    context 'point-in-time' do
      subject { Post.past_day }
      its(:count){ should eq 1 }
    end

    context 'timespan' do
      subject { Event.past_day }
      its(:count){ should eq 5 }
    end

    context 'timespan strict' do
      subject { Event.past_day(strict: true) }
      its(:count){ should eq 0 }
    end
  end

  describe '#past_week' do
    context 'point-in-time' do
      subject { Post.past_week }
      its(:count){ should eq 3 }
    end

    context 'timespan' do
      subject { Event.past_week }
      its(:count){ should eq 7 }
    end

    context 'timespan strict' do
      subject { Event.past_week(strict: true) }
      its(:count){ should eq 0 }
    end
  end

  describe '#past_fortnight' do
    context 'point-in-time' do
      subject { Post.past_fortnight }
      its(:count){ should eq 4 }
    end

    context 'timespan' do
      subject { Event.past_fortnight }
      its(:count){ should eq 8 }
    end

    context 'timespan strict' do
      subject { Event.past_fortnight(strict: true) }
      its(:count){ should eq 1 }
    end
  end

  describe '#past_month' do
    context 'point-in-time' do
      subject { Post.past_month }
      its(:count){ should eq 8 }
    end

    context 'timespan' do
      subject { Event.past_month }
      its(:count){ should eq 12 }
    end

    context 'timespan strict' do
      subject { Event.past_month(strict: true) }
      its(:count){ should eq 4 }
    end
  end

  describe '#past_year' do
    context 'point-in-time' do
      subject { Post.past_year }
      its(:count){ should eq 10 }
    end

    context 'timespan' do
      subject { Event.past_year }
      its(:count){ should eq 13 }
    end

    context 'timespan strict' do
      subject { Event.past_year(strict: true) }
      its(:count){ should eq 8 }
    end
  end

  describe '#next_day' do
    context 'point-in-time' do
      subject { Post.next_day }
      its(:count){ should eq 2 }
    end

    context 'timespan' do
      subject { Event.next_day }
      its(:count){ should eq 5 }
    end

    context 'timespan strict' do
      subject { Event.next_day(strict: true) }
      its(:count){ should eq 0 }
    end
  end

  describe '#next_week' do
    context 'point-in-time' do
      subject { Post.next_week }
      its(:count){ should eq 3 }
    end

    context 'timespan' do
      subject { Event.next_week }
      its(:count){ should eq 7 }
    end

    context 'timespan strict' do
      subject { Event.next_week(strict: true) }
      its(:count){ should eq 0 }
    end
  end

  describe '#next_fortnight' do
    context 'point-in-time' do
      subject { Post.next_fortnight }
      its(:count){ should eq 5 }
    end

    context 'timespan' do
      subject { Event.next_fortnight }
      its(:count){ should eq 7 }
    end

    context 'timespan strict' do
      subject { Event.next_fortnight(strict: true) }
      its(:count){ should eq 0 }
    end
  end

  describe '#next_month' do
    context 'point-in-time' do
      subject { Post.next_month }
      its(:count){ should eq 6 }
    end

    context 'timespan' do
      subject { Event.next_month }
      its(:count){ should eq 9 }
    end

    context 'timespan strict' do
      subject { Event.next_month(strict: true) }
      its(:count){ should eq 3 }
    end
  end

  describe '#next_year' do
    context 'point-in-time' do
      subject { Post.next_year }
      its(:count){ should eq 12 }
    end

    context 'timespan' do
      subject { Event.next_year }
      its(:count){ should eq 14 }
    end

    context 'timespan strict' do
      subject { Event.next_year(strict: true) }
      its(:count){ should eq 9 }
    end
  end
end
