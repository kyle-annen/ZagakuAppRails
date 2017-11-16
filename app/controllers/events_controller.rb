include GoogleCalendarService

class EventsController < ApplicationController

  def index
    GoogleCalendarService.sync_calendar
    @events = Event.all
  end
end