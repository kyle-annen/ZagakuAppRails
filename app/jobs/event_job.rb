include GoogleCalendarService

# job is scheduled in /config/chronotab.rb
class EventJob < ApplicationJob

  def perform
    GoogleCalendarService.sync_calendar
  end
end
