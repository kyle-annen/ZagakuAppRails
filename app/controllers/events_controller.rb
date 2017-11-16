include GoogleCalendarService

class EventsController < ApplicationController

  def index
    GoogleCalendarService.sync_calendar
    @upcoming_events = Event.where('start_time > ?', DateTime.now).order('start_time asc')
  end
end