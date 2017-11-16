# include GoogleCalendarService

module EventsHelper
  
  def get_upcoming_events_by_week
    upcoming_events = Event.where('start_time > ?', DateTime.now)
    upcoming_events_by_week = upcoming_events.group_by { 
      |event| event.start_time.to_date.cweek
    }
  end
end
