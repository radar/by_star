require 'spec_helper'

describe ByStar::Normalization do

  let(:options){ {} }

  shared_examples_for 'time normalization from string' do

    context 'date String' do
      let(:input){ '2014-01-01' }
      it { should eq Time.zone.parse('2014-01-01 12:00:00') }
    end

    context 'time String' do
      let(:input){ '2014-01-01 15:00:00' }
      it { should eq Time.zone.parse('2014-01-01 15:00:00') }
    end
  end

  shared_examples_for 'time normalization from date/time' do
    context 'Date' do
      let(:input){ Date.parse('2014-01-01') }
      it { should eq Time.zone.parse('2014-01-01 00:00:00') }
    end

    context 'DateTime' do
      let(:input){ DateTime.parse("2014-01-01 15:00:00 #{Time.zone}") }
      it { should eq Time.zone.parse('2014-01-01 15:00:00') }
    end

    context 'Time' do
      let(:input){ Time.zone.parse('2014-01-01 15:00:00') }
      it { should eq Time.zone.parse('2014-01-01 15:00:00') }
    end
  end

  describe '#time' do
    subject { ByStar::Normalization.time(input) }
    it_behaves_like 'time normalization from string'
    it_behaves_like 'time normalization from date/time'
  end

  describe '#time_string_fallback' do

    it 'should parse date String to Time at beginning of day' do
      d = '2014-01-01'
      subject.time_string_fallback(d).should eq Time.zone.parse('2014-01-01 00:00:00')
    end

    it 'should parse time String to Time' do
      dt = '2014-01-01 15:00:00'
      subject.time_string_fallback(dt).should eq Time.zone.parse('2014-01-01 15:00:00')
    end
  end

  describe '#week' do
    subject { ByStar::Normalization.week(input, options) }
    it_behaves_like 'time normalization from string'
    it_behaves_like 'time normalization from date/time'

    context 'Fixnum 0' do
      let(:input){ 0 }
      it { should eq Time.zone.parse('2014-01-01 00:00:00') }
    end

    context 'Fixnum 20' do
      let(:input){ 20 }
      it { should eq Time.zone.parse('2014-05-21 00:00:00') }
    end

    context 'with year option' do
      let(:options){ { :year => 2011 } }

      context 'Fixnum 0' do
        let(:input){ 0 }
        it { should eq Time.zone.parse('2011-01-01 00:00:00') }
      end

      context 'Fixnum 20' do
        let(:input){ 20 }
        it { should eq Time.zone.parse('2011-05-21 00:00:00') }
      end
    end
  end

  describe '#fortnight' do
    subject { ByStar::Normalization.fortnight(input, options) }
    it_behaves_like 'time normalization from string'
    it_behaves_like 'time normalization from date/time'

    context 'Fixnum 0' do
      let(:input){ 0 }
      it { should eq Time.zone.parse('2014-01-01 00:00:00') }
    end

    context 'Fixnum 26' do
      let(:input){ 26 }
      it { should eq Time.zone.parse('2014-12-31 00:00:00') }
    end

    context 'out of range' do
      specify { ->{ ByStar::Normalization.fortnight(-1) }.should raise_error(ByStar::ParseError, 'Fortnight number must be between 0 and 26') }
      specify { ->{ ByStar::Normalization.fortnight(27) }.should raise_error(ByStar::ParseError, 'Fortnight number must be between 0 and 26') }
    end

    context 'with year option' do
      let(:options){ { :year => 2011 } }

      context 'Fixnum 0' do
        let(:input){ 0 }
        it { should eq Time.zone.parse('2011-01-01 00:00:00') }
      end

      context 'Fixnum 26' do
        let(:input){ 26 }
        it { should eq Time.zone.parse('2011-12-31 00:00:00') }
      end
    end
  end

  describe '#month' do
    subject { ByStar::Normalization.month(input, options) }
    it_behaves_like 'time normalization from date/time'

    context 'month abbr String' do
      let(:input){ 'Feb' }
      it { should eq Time.zone.parse('2014-02-01 00:00:00') }
    end

    context 'month full String' do
      let(:input){ 'February' }
      it { should eq Time.zone.parse('2014-02-01 00:00:00') }
    end

    context 'number String' do
      let(:input){ '2' }
      it { should eq Time.zone.parse('2014-02-01 00:00:00') }
    end

    context 'Fixnum' do
      let(:input){ 2 }
      it { should eq Time.zone.parse('2014-02-01 00:00:00') }
    end

    context 'out of range' do
      specify { ->{ ByStar::Normalization.month(0) }.should raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name') }
      specify { ->{ ByStar::Normalization.month(13) }.should raise_error(ByStar::ParseError, 'Month must be a number between 1 and 12 or a month name') }
    end

    context 'with year option' do
      let(:options){ { :year => 2011 } }

      context 'month abbr String' do
        let(:input){ 'Dec' }
        it { should eq Time.zone.parse('2011-12-01 00:00:00') }
      end

      context 'Fixnum 12' do
        let(:input){ 10 }
        it { should eq Time.zone.parse('2011-10-01 00:00:00') }
      end
    end
  end

  describe '#quarter' do
    subject { ByStar::Normalization.quarter(input, options) }
    it_behaves_like 'time normalization from string'
    it_behaves_like 'time normalization from date/time'

    context 'Fixnum 1' do
      let(:input){ 1 }
      it { should eq Time.zone.parse('2014-01-01 00:00:00') }
    end

    context 'Fixnum 2' do
      let(:input){ 2 }
      it { should eq Time.zone.parse('2014-04-01 00:00:00') }
    end

    context 'Fixnum 3' do
      let(:input){ 3 }
      it { should eq Time.zone.parse('2014-07-01 00:00:00') }
    end

    context 'Fixnum 4' do
      let(:input){ 4 }
      it { should eq Time.zone.parse('2014-10-01 00:00:00') }
    end

    context 'with year option' do
      let(:options){ { :year => 2011 } }

      context 'Fixnum 3' do
        let(:input){ 3 }
        it { should eq Time.zone.parse('2011-07-01 00:00:00') }
      end
    end

    context 'out of range' do
      specify { ->{ ByStar::Normalization.quarter(0) }.should raise_error(ByStar::ParseError, 'Quarter number must be between 1 and 4') }
      specify { ->{ ByStar::Normalization.quarter(5) }.should raise_error(ByStar::ParseError, 'Quarter number must be between 1 and 4') }
    end
  end

  describe '#year' do
    subject { ByStar::Normalization.year(input, options) }
    it_behaves_like 'time normalization from string'
    it_behaves_like 'time normalization from date/time'

    context 'Fixnum 69' do
      let(:input){ 69 }
      it { should eq Time.zone.parse('2069-01-01 00:00:00') }
    end

    context 'Fixnum 99' do
      let(:input){ 99 }
      it { should eq Time.zone.parse('1999-01-01 00:00:00') }
    end

    context 'Fixnum 2001' do
      let(:input){ 1 }
      it { should eq Time.zone.parse('2001-01-01 00:00:00') }
    end

    context 'String 01' do
      let(:input){ '01' }
      it { should eq Time.zone.parse('2001-01-01 00:00:00') }
    end

    context 'String 70' do
      let(:input){ '70' }
      it { should eq Time.zone.parse('1970-01-01 00:00:00') }
    end

    context 'String 2001' do
      let(:input){ '2001' }
      it { should eq Time.zone.parse('2001-01-01 00:00:00') }
    end
  end
end
