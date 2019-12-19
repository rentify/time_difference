require 'rubygems'
require "active_support/all"

class TimeDifference

  private_class_method :new

  TIME_COMPONENTS = [:years, :months, :weeks, :days, :hours, :minutes, :seconds]

  def self.between(start_time, end_time)
    new(start_time, end_time)
  end

  def in_years
    in_component(:years)
  end

  def in_months
    @months = 0.0
    @start_time, @end_time = @end_time, @start_time if @end_time < @start_time
    @end_time.year - @start_time.year >= 1 ? set_multiple_year_months : (@end_time.month != @start_time.month ? set_same_year_months : set_same_month_months)
    @months.round(2)
  end

  def in_weeks
    in_component(:weeks)
  end

  def in_days
    in_component(:days)
  end

  def in_hours
    in_component(:hours)
  end

  def in_minutes
    in_component(:minutes)
  end

  def in_seconds
    @time_diff
  end

  def in_each_component
    Hash[TIME_COMPONENTS.map do |time_component|
      [time_component, public_send("in_#{time_component}")]
    end]
  end

  def in_general
    remaining = @time_diff

    Hash[TIME_COMPONENTS.map do |time_component|
      rounded_time_component = (remaining / 1.send(time_component)).floor
      remaining -= rounded_time_component.send(time_component)

      [time_component, rounded_time_component]
    end]
  end

  private

  def initialize(start_time, end_time)
    @start_time = start_time.to_time
    @end_time = end_time.to_time

    start_time_in_seconds = time_in_seconds(start_time)
    end_time_in_seconds = time_in_seconds(end_time)

    @time_diff = (end_time_in_seconds - start_time_in_seconds).abs
    # @time_diff += 86400 if include_leap_year_day?(start_time, end_time)
  end

  def time_in_seconds(time)
    time.to_time.to_f
  end

  def in_component(component)
    (@time_diff / 1.send(component)).round(2)
  end

  def set_multiple_year_months
    first_year_months(first_year_days)
    last_year_months(last_year_days)
    @months += ((@end_time.year - @start_time.year) - 1) * 12 if @end_time.year - @start_time.year >= 2
  end

  def first_year_months(days)
    set_months_array(@start_time)
    @months_array.reverse.each do |month_days|
      break if days <= 0

      days < month_days ? @months += (days / month_days) : @months += 1
      days -= month_days
    end
  end

  def last_year_months(days)
    set_months_array(@end_time)
    @months_array.each do |month_days|
      break if days <= 0

      days < month_days ? @months += (days / month_days) : @months += 1
      days -= month_days
    end
  end

  def first_year_days
    (((@start_time + 1.year).at_beginning_of_year - @start_time) / 86400) - 1
  end

  def last_year_days
    ((@end_time - @end_time.at_beginning_of_year) / 86400 + 1)
  end

  def set_same_year_months
    set_months_array(@start_time)
    @start_time.day == @end_time.day ? @months += 1 : set_partial_months
    @months += (@end_time.month - @start_time.month) - 1
  end

  def set_partial_months
    first_month_days = @months_array[@start_time.month - 1] - @start_time.day
    @months += (first_month_days.to_f / @months_array[@start_time.month - 1].to_f)
    @months += (@end_time.day.to_f / @months_array[@end_time.month - 1].to_f)
  end

  def set_same_month_months
    set_months_array(@start_time)
    @months += (@end_time.day - @start_time.day).to_f / @months_array[@start_time.month - 1.to_f]
  end

  def set_months_array(time_to_set)
    @months_array = time_to_set.to_date.leap? ? leap_year_months : normal_year_months
  end

  def normal_year_months
    [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  end

  def leap_year_months
    [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  end

  # def include_leap_year_day?(start_date, end_date)
  #   start_date = start_date.to_date
  #   end_date = end_date.to_date
  #   (start_date..end_date).select{ |date| date.month == 2 && date.day > 28 }.any? && in_days >= 1.0
  # end

end
