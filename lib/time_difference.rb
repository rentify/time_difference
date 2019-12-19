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
    # (@time_diff / (1.day * 30.42)).round(2)
    months = 0
    @start_time, @end_time = @end_time, @start_time if @end_time < @start_time

    if @end_time.year - @start_time.year >= 1
      first_year_days = ((@start_time + 1.year).at_beginning_of_year - @start_time) / 86400
      first_year_months(first_year_days)

      last_year_days = (@end_time - @end_time.at_beginning_of_year) / 86400
      last_year_months(last_year_days)

      months += (@end_time.year - @start_time.year) * 12 if @end_time.year - @start_time.year >= 2
    elsif (@end_time.year - @start_time.year).zero? && @end_time.month != @start_time.month
      if @start_time.to_date.leap?
        first_month_days = leap_year_months[@start_time.month - 1] - @start_time.day
        months += (first_month_days / leap_year_months[@start_time.month - 1])

        months += (@end_time.day / leap_year_months[@end_time.month - 1])

        months += (@end_time.month - @start_time.month) - 1
      else
        first_month_days = normal_year_months[@start_time.month - 1] - @start_time.day
        months += (first_month_days / normal_year_months[@start_time.month - 1])

        months += (@end_time.day / normal_year_months[@end_time.month - 1])

        months += (@end_time.month - @start_time.month) - 1
      end
    elsif (@end_time.year - @start_time.year).zero? && @end_time.month == @start_time.month
      if @start_time.to_date.leap?
        months += (@end_time.day - @start_time.day) / leap_year_months[@start_time.month - 1]
      else
        months += (@end_time.day - @start_time.day) / normal_year_months[@start_time.month - 1]
      end
    end
    months
  end

  def first_year_months(days)
    if @start_time.to_date.leap?
      leap_year_months.reverse.each do |month_days|
        if days < month_days
          months += (days / month_days)
        else
          months += 1
        end
        days -= month_days
      end
    else
      normal_year_months.reverse.each do |month_days|
        if days < month_days
          months += (days / month_days)
        else
          months += 1
        end
        days -= month_days
      end
    end
  end

  def last_year_months(days)
    if @end_time.to_date.leap?
      leap_year_months.each do |month_days|
        if days < month_days
          months += (days / month_days)
        else
          months += 1
        end
    else
      normal_year_months.each do |month_days|
        if days < month_days
          months += (days / month_days)
        else
          months += 1
        end
      end
    end
  end

  def normal_year_months
    [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  end

  def leap_year_months
    [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
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
    @time_diff += 86400 if include_leap_year_day?(start_time, end_time)
  end

  def time_in_seconds(time)
    time.to_time.to_f
  end

  def in_component(component)
    (@time_diff / 1.send(component)).round(2)
  end

  def include_leap_year_day?(start_date, end_date)
    start_date = start_date.to_date
    end_date = end_date.to_date
    (start_date..end_date).select{ |date| date.month == 2 && date.day > 28 }.any? && in_days >= 1.0
  end

end
