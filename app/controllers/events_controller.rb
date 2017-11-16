include GoogleCalendarService

class EventsController < ApplicationController

  def index
    GoogleCalendarService.sync_calendar
    @events = Event.where('start_time > ?', DateTime.now).order('start_time asc')
  end
end