include EventsHelper

class EventsController < ApplicationController
  def index
    @time_zone = "America/Chicago"
    @date = set_date 
    @events = EventsHelper.get_events_by_week(@date)
    @days_per_week = 4
  end

  private

  def event_params
    params.permit(:date)
  end

  def set_date
    date = Date.today
    date = event_params[:date].to_date if event_params[:date]
    date
  end
end