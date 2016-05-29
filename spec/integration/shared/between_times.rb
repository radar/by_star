require 'spec_helper'

shared_examples_for 'between_times' do

  describe '#between_times' do
    subject { Post.between_times(Time.zone.parse('2014-01-01'), Time.zone.parse('2014-01-06')) }

    if testing_active_record?
      it { is_expected.to be_a(ActiveRecord::Relation) }
    else testing_mongoid?
      it { is_expected.to be_a(Mongoid::Criteria) }
    end

    it { expect(subject.count).to eql(3) }

    context 'one-sided query' do

      context 'point query' do

        context 'only start time' do
          subject { Post.between_times(Time.zone.parse('2014-01-01'), nil) }
          it { expect(subject.count).to eql(12) }
        end

        context 'only end time' do
          subject { Post.between_times(nil, Time.zone.parse('2014-01-01')) }
          it { expect(subject.count).to eql(10) }

          context 'neither start nor end time' do
            subject { Post.between_times(nil, nil) }
            it { expect(subject.count).to eql(22) }
          end
        end
      end

      context 'timespan loose query' do

        context 'only start time' do
          subject { Event.between_times(Time.zone.parse('2014-01-01'), nil, strict: false) }
          it { expect(subject.count).to eql(9) }
        end

        context 'only end time' do
          subject { Event.between_times(nil, Time.zone.parse('2014-01-01'), strict: false) }
          it { expect(subject.count).to eql(13) }

          context 'neither start nor end time' do
            subject { Event.between_times(nil, nil) }
            it { expect(subject.count).to eql(22) }
          end
        end
      end

      context 'timespan strict query' do

        context 'only start time' do
          subject { Event.between_times(Time.zone.parse('2014-01-01'), nil) }
          it { expect(subject.count).to eql(9) }
        end

        context 'only end time' do
          subject { Event.between_times(nil, Time.zone.parse('2014-01-01')) }
          it { expect(subject.count).to eql(13) }

          context 'neither start nor end time' do
            subject { Event.between_times(nil, nil) }
            it { expect(subject.count).to eql(22) }
          end
        end
      end
    end
  end

  if testing_mongoid?
    describe '#between' do
      it 'should not override Mongoid between method' do
        posts = Post.between(created_at: Time.zone.parse('2014-01-01')..Time.zone.parse('2014-01-06'))
        expect(posts.count).to eql(3)
      end
    end
  end
end
