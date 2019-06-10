require 'spec_helper'

shared_examples_for 'between_dates' do

  describe '#between_dates' do
    subject { Post.between_dates(Time.zone.parse('2014-01-01'), Time.zone.parse('2014-01-06')) }

    if testing_active_record?
      it { is_expected.to be_a(ActiveRecord::Relation) }
    else testing_mongoid?
      it { is_expected.to be_a(Mongoid::Criteria) }
    end

    it { expect(subject.count).to eql(3) }

    context 'one-sided query' do

      context 'point query' do

        context 'only start time' do
          subject { Post.between_dates(Time.zone.parse('2014-01-01'), nil) }
          it { expect(subject.count).to eql(12) }
        end

        context 'only end time' do
          subject { Post.between_dates(nil, Time.zone.parse('2014-01-01')) }
          it { expect(subject.count).to eql(12) }

          context 'neither start nor end time' do
            subject { Post.between_dates(nil, nil) }
            it { expect(subject.count).to eql(22) }
          end
        end
      end

      context 'timespan loose query' do

        context 'only start time' do
          subject { Event.between_dates(Time.zone.parse('2014-01-01'), nil, strict: false) }
          it { expect(subject.count).to eql(17) }
        end

        context 'only end time' do
          subject { Event.between_dates(nil, Time.zone.parse('2014-01-01'), strict: false) }
          it { expect(subject.count).to eql(13) }

          context 'neither start nor end time' do
            subject { Event.between_dates(nil, nil) }
            it { expect(subject.count).to eql(30) }
          end
        end
      end

      context 'timespan strict query' do

        context 'only start time' do
          subject { Event.between_dates(Time.zone.parse('2014-01-01'), nil) }
          it { expect(subject.count).to eql(17) }
        end

        context 'only end time' do
          subject { Event.between_dates(nil, Time.zone.parse('2014-01-01')) }
          it { expect(subject.count).to eql(13) }

          context 'neither start nor end time' do
            subject { Event.between_dates(nil, nil) }
            it { expect(subject.count).to eql(30) }
          end
        end
      end
    end

    context 'two-sided query' do
      context 'DST starts (Sydney)', sydney: true do
        context 'day before' do
          subject { Event.between_dates(Date.parse('2020-04-04'), Date.parse('2020-04-04'), offset: 5.hours) }
          it { expect(subject.count).to eql(3) }
        end

        context 'same day' do
          subject { Event.between_dates(Date.parse('2020-04-05'), Date.parse('2020-04-05'), offset: 5.hours) }
          it { expect(subject.count).to eql(1) }
        end
      end

      context 'when DST ends (Sydney)', sydney: true do
        context 'day before' do
          subject { Event.between_dates(Date.parse('2020-10-03'), Date.parse('2020-10-03'), offset: 5.hours) }
          it { expect(subject.count).to eql(1) }
        end

        context 'same day' do
          subject { Event.between_dates(Date.parse('2020-10-04'), Date.parse('2020-10-04'), offset: 5.hours) }
          it { expect(subject.count).to eql(3) }
        end
      end
    end
  end
end
