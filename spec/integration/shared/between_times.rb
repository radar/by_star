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
