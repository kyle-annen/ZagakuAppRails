include EventsHelper

class EventsController < ApplicationController
  before_action :require_employee

  def index
    @time_zone = 'America/Chicago'
    @date = set_date
    @events = EventsHelper.get_events_by_week(@date)
    @days_per_week = 5
  end

  def create
    base_url = 'https://calendar.google.com/calendar/r/eventedit?action=TEMPLATE'
    parameters = ''
    name = "#{event_params[:first_name]} #{event_params[:last_name][0]}."
    title = event_params[:talk_title].to_s
    parameters += "&text=Zagaku+-+#{name}+-+#{title}"
    event_times = "#{start_datetime}/#{end_datetime}"
    parameters += "&dates=#{event_times}"
    parameters += "&location=#{event_params[:location]}"
    calendar_id = '8thlight.com_2lmksu0derpihviusb1ml7hca4@group.calendar.google.com'
    parameters += "&src=#{calendar_id}"
    parameters += '&output=xml'
    parameters += '&sf=true'
    parameters += "&details=#{event_params[:summary]}"
    redirect_to base_url + parameters
  end


  private

  def require_employee
    unless current_user.employee?
      redirect_to root_path
    end
  end

  def event_params
    params.permit(
      :date,
      :first_name,
      :last_name,
      :talk_title,
      :location,
      :summary,
      :time_zone,
      end_time: [],
      start_time: []
    )
  end

  def start_datetime
    time_zone_offset = ActiveSupport::TimeZone[event_params[:time_zone]]
                       .formatted_offset
    time_string = event_params[:date].to_s + ' ' +
                  event_params[:start_time][0]
    time = DateTime.parse(time_string) + time_zone_offset.to_i.hours
    time.strftime('%Y%m%dT%H%M%SZ')
  end

  def end_datetime
    time_zone_offset = ActiveSupport::TimeZone[event_params[:time_zone]]
                       .formatted_offset
    time_string = event_params[:date].to_s + ' ' +
                  event_params[:end_time][0]
    time = DateTime.parse(time_string) + time_zone_offset.to_i.hours
    time.strftime('%Y%m%dT%H%M%SZ')
  end

  def set_date
    date = Date.today
    date = event_params[:date].to_date if event_params[:date]
    date
  end
end
