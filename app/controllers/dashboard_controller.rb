class DashboardController < ApplicationController
  def index
    day = DateTime.now.in_time_zone(Time.zone)
    setup(day.beginning_of_day, day.end_of_day)
  end

  def yesterday
    day = DateTime.yesterday.in_time_zone(Time.zone)
    setup(day.beginning_of_day, day.end_of_day)
    render :index
  end

  def this_week
    day = DateTime.now.in_time_zone(Time.zone)
    setup(day.beginning_of_week, day.end_of_week)
    render :index
  end

  def last_week
    day = DateTime.now.in_time_zone(Time.zone) - 1.week
    setup(day.beginning_of_week, day.end_of_week)
    render :index
  end

  def this_month
    day = DateTime.now.in_time_zone(Time.zone)
    setup(day.beginning_of_month, day.end_of_month)
    render :index
  end

  def last_month
    day = DateTime.now.in_time_zone(Time.zone) - 1.month
    setup(day.beginning_of_month, day.end_of_month)
    render :index
  end

  def all
    day = DateTime.now.in_time_zone(Time.zone)
    setup(day - 10.years, day)
    render :index
  end


  protected
  def setup(start_time, end_time)
    authorize :dashboard, :show?
    @start_time = start_time
    @end_time = end_time
  end
end
