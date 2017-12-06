class EventApiController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    if event_params.include?(:time_period)
      @events = events_by_time_period
      render json: @events,
             status: :created
    else
      render json: { error: 'Valid time period required.' },
             status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.permit(:time_period)
  end

  def events_by_time_period
    case event_params[:time_period]
    when 'upcoming'
      Event.where('Date(start_time) >= ?', Date.today)
    when 'past'
      Event.where('Date(start_time) < ?', Date.today)
    when 'all'
      Event.all
    else {}
    end
  end
end
