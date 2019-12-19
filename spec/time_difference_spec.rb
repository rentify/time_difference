require 'spec_helper'

describe TimeDifference do

  def self.with_each_class(&block)
    classes = [Time, Date, DateTime]

    classes.each do |clazz|
      context "with a #{clazz.name} class" do
        instance_exec clazz, &block
      end
    end
  end

  describe ".between" do
    it "returns a new TimeDifference instance" do
      start_time = Time.new(2011, 1)
      end_time = Time.new(2011, 12)

      expect(TimeDifference.between(start_time, end_time)).to be_a(TimeDifference)
    end
  end

  describe "#in_each_component" do
    with_each_class do |clazz|
      it "returns time difference in each component" do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_each_component).to eql({years: 0.91, months: 10.98, weeks: 47.71, days: 334.0, hours: 8016.0, minutes: 480960.0, seconds: 28857600.0})
      end
    end
  end

  describe "#in_general" do
    with_each_class do |clazz|
      it "returns time difference in general that matches the total seconds" do
        start_time = clazz.new(2009, 11)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_general).to eql({years: 1, months: 2, weeks: 0, days: 0, hours: 18, minutes: 0, seconds: 0})
      end
    end
  end

  describe "#in_years" do
    with_each_class do |clazz|
      it "returns time difference in years based on Wolfram Alpha" do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_years).to eql(0.91)
      end

      it "returns an absolute difference" do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_years).to eql(0.91)
      end
    end
  end

  describe "#in_months" do
    with_each_class do |clazz|
      context '1 whole month between dates' do
        context 'start_time is before end_time' do
          context 'normal year' do
            it 'returns 1.0' do
              start_time = clazz.new(2019, 1, 1)
              end_time = clazz.new(2019, 2, 1)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2019, 2, 1)
              end_time = clazz.new(2019, 3, 1)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2019, 1, 15)
              end_time = clazz.new(2019, 2, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2019, 12, 15)
              end_time = clazz.new(2020, 1, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2019, 9, 15)
              end_time = clazz.new(2019, 8, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end
          end

          context 'leap year' do
            it 'returns 1.0' do
              start_time = clazz.new(2020, 1, 1)
              end_time = clazz.new(2020, 2, 1)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2020, 2, 1)
              end_time = clazz.new(2020, 3, 1)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2020, 2, 15)
              end_time = clazz.new(2020, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2020, 9, 19)
              end_time = clazz.new(2020, 10, 19)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2020, 2, 29)
              end_time = clazz.new(2020, 3, 29)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end
          end
        end

        context 'end_time is before start_time' do
          context 'normal year' do
            it 'returns 1.0' do
              start_time = clazz.new(2019, 2, 1)
              end_time = clazz.new(2019, 1, 1)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2019, 9, 12)
              end_time = clazz.new(2019, 8, 12)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2020, 1, 20)
              end_time = clazz.new(2019, 12, 20)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end
          end

          context 'leap year' do
            it 'returns 1.0' do
              start_time = clazz.new(2020, 9, 12)
              end_time = clazz.new(2020, 8, 12)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end

            it 'returns 1.0' do
              start_time = clazz.new(2020, 3, 15)
              end_time = clazz.new(2020, 2, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(1.0)
            end
          end
        end
      end

      context 'start_time and end_time are in different years' do
        context 'start_time is before end_time' do
          context 'does not include a leap year' do
            it 'returns 12.0' do
              start_time = clazz.new(2018, 3, 15)
              end_time = clazz.new(2019, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(12.0)
            end

            it 'returns 18.0' do
              start_time = clazz.new(2018, 3, 15)
              end_time = clazz.new(2019, 9, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(18.0)
            end

            it 'returns 24.0' do
              start_time = clazz.new(2017, 3, 15)
              end_time = clazz.new(2019, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(24.0)
            end

            it 'returns 36.0' do
              start_time = clazz.new(2016, 3, 15)
              end_time = clazz.new(2019, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(36.0)
            end
          end

          context 'includes a leap year' do
            it 'returns 12.0' do
              start_time = clazz.new(2019, 3, 15)
              end_time = clazz.new(2020, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(12.0)
            end

            it 'returns 18.0' do
              start_time = clazz.new(2019, 3, 15)
              end_time = clazz.new(2020, 9, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(18.0)
            end

            it 'returns 24.0' do
              start_time = clazz.new(2018, 3, 15)
              end_time = clazz.new(2020, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(24.0)
            end

            it 'returns 24.0' do
              start_time = clazz.new(2019, 3, 15)
              end_time = clazz.new(2021, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(24.0)
            end

            it 'returns 36.0' do
              start_time = clazz.new(2017, 3, 15)
              end_time = clazz.new(2020, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(36.0)
            end

            it 'returns 36.0' do
              start_time = clazz.new(2018, 3, 15)
              end_time = clazz.new(2021, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(36.0)
            end

            it 'returns 36.0' do
              start_time = clazz.new(2020, 3, 15)
              end_time = clazz.new(2023, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(36.0)
            end
          end
        end

        context 'end_time is before start_time' do
          context 'does not include a leap year' do
            it 'returns 12.0' do
              start_time = clazz.new(2019, 3, 15)
              end_time = clazz.new(2018, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(12.0)
            end

            it 'returns 18.0' do
              start_time = clazz.new(2019, 9, 15)
              end_time = clazz.new(2018, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(18.0)
            end

            it 'returns 24.0' do
              start_time = clazz.new(2019, 3, 15)
              end_time = clazz.new(2017, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(24.0)
            end

            it 'returns 36.0' do
              start_time = clazz.new(2019, 3, 15)
              end_time = clazz.new(2016, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(36.0)
            end
          end

          context 'includes a leap year' do
            it 'returns 12.0' do
              start_time = clazz.new(2020, 3, 15)
              end_time = clazz.new(2019, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(12.0)
            end

            it 'returns 24.0' do
              start_time = clazz.new(2020, 3, 15)
              end_time = clazz.new(2018, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(24.0)
            end

            it 'returns 36.0' do
              start_time = clazz.new(2020, 3, 15)
              end_time = clazz.new(2017, 3, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(1)).to eql(36.0)
            end
          end
        end
      end

      context 'start_time and end_time are in the same month and same year' do
        context 'start_time is before end_time' do
          context 'normal year' do
            it 'returns 0.5' do
              start_time = clazz.new(2019, 4, 15)
              end_time = clazz.new(2019, 4, 30)

              expect(TimeDifference.between(start_time, end_time).in_months.round(2)).to eql(0.5)
            end

            it 'returns 0.5' do
              start_time = clazz.new(2019, 4, 1)
              end_time = clazz.new(2019, 4, 15)

              expect(TimeDifference.between(start_time, end_time).in_months.round(2)).to eql(0.5)
            end

            it 'returns 0.97' do
              start_time = clazz.new(2019, 4, 1)
              end_time = clazz.new(2019, 4, 30)

              expect(TimeDifference.between(start_time, end_time).in_months.round(2)).to eql(0.97)
            end

            it 'returns 0.33' do
              start_time = clazz.new(2019, 4, 1)
              end_time = clazz.new(2019, 4, 11)

              expect(TimeDifference.between(start_time, end_time).in_months.round(2)).to eql(0.33)
            end

            it '1st to 28th February returns 0.96' do
              start_time = clazz.new(2019, 2, 1)
              end_time = clazz.new(2019, 2, 28)

              expect(TimeDifference.between(start_time, end_time).in_months.round(2)).to eql(0.96)
            end
          end

          context 'leap year' do
            it '1st to 28th February returns 0.93' do
              start_time = clazz.new(2020, 2, 1)
              end_time = clazz.new(2020, 2, 28)

              expect(TimeDifference.between(start_time, end_time).in_months.round(2)).to eql(0.93)
            end

            it '1st to 29th February returns 0.97' do
              start_time = clazz.new(2020, 2, 1)
              end_time = clazz.new(2020, 2, 29)

              expect(TimeDifference.between(start_time, end_time).in_months.round(2)).to eql(0.97)
            end
          end
        end
      end







      # it "returns time difference in months based on Wolfram Alpha" do
      #   start_time = clazz.new(2011, 1)
      #   end_time = clazz.new(2011, 12)

      #   expect(TimeDifference.between(start_time, end_time).in_months).to eql(10.98)
      # end

      # it "returns an absolute difference" do
      #   start_time = clazz.new(2011, 12)
      #   end_time = clazz.new(2011, 1)

      #   expect(TimeDifference.between(start_time, end_time).in_months).to eql(10.98)
      # end

      # context "in a leap year" do
      #   it "adds an extra day to cover 29th February" do
      #     start_time = clazz.new(2012, 1)
      #     end_time = clazz.new(2012, 3)

      #     expect(TimeDifference.between(start_time, end_time).in_months).to eql(2.01)
      #   end

      #   it "does not add an extra day if the difference is within the 29th February" do
      #     start_time = clazz.new(2012, 2, 29, 1)
      #     end_time = clazz.new(2012, 2, 29, 2)

      #     expect(TimeDifference.between(start_time, end_time).in_months).to eql(0.0)
      #   end

      #   it "doesn't add a day when the date period does not cover 29th February" do
      #     start_time = clazz.new(2012, 3, 27)
      #     end_time = clazz.new(2012, 4, 27)

      #     expect(TimeDifference.between(start_time, end_time).in_months).to eql(1.02)
      #   end

      # end
    end
  end

  describe "#in_weeks" do
    with_each_class do |clazz|
      it "returns time difference in weeks based on Wolfram Alpha" do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_weeks).to eql(47.71)
      end

      it "returns an absolute difference" do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_weeks).to eql(47.71)
      end
    end
  end

  describe "#in_days" do
    with_each_class do |clazz|
      it "returns time difference in weeks based on Wolfram Alpha" do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_days).to eql(334.0)
      end

      it "returns an absolute difference" do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_days).to eql(334.0)
      end

      context "it's a leap year" do
        it 'calculates the correct number of days when not including 29th February' do
          start_time = clazz.new(2020, 2, 26)
          end_time = clazz.new(2020, 2, 28)

          expect(TimeDifference.between(start_time, end_time).in_days).to eql(2.0)
        end

        it 'calculates the correct number of days including 29th February' do
          start_time = clazz.new(2020, 2, 28)
          end_time = clazz.new(2020, 3, 1)

          expect(TimeDifference.between(start_time, end_time).in_days).to eql(2.0)
        end
      end
    end
  end

  describe "#in_hours" do
    with_each_class do |clazz|
      it "returns time difference in hours based on Wolfram Alpha" do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_hours).to eql(8016.0)
      end

      it "returns an absolute difference" do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_hours).to eql(8016.0)
      end
    end
  end

  describe "#in_minutes" do
    with_each_class do |clazz|
      it "returns time difference in minutes based on Wolfram Alpha" do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_minutes).to eql(480960.0)
      end

      it "returns an absolute difference" do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_minutes).to eql(480960.0)
      end
    end
  end

  describe "#in_seconds" do
    with_each_class do |clazz|
      it "returns time difference in seconds based on Wolfram Alpha" do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_seconds).to eql(28857600.0)
      end

      it "returns an absolute difference" do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_seconds).to eql(28857600.0)
      end
    end
  end
end
