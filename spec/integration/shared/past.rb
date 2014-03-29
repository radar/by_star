require 'spec_helper'

shared_examples_for 'past' do

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

end
