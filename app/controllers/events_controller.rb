include EventsHelper

class EventsController < ApplicationController
  def index
    @time_zone = "America/Chicago"
    @date = Date.today
    @date = event_params[:date].to_date if event_params[:date]
    @events = EventsHelper.get_events_by_week(@date)
  end

  private

  def event_params
    params.permit(:date)
  end


end