module GoogleCalendarService
  def sync_calendar
    calendar = get_calendar_events
    save_calendar_events(calendar)
  end

  def get_calendar_events
    cal_file = open(ENV['GOOGLE_ICAL_LINK']) { |f| f.read }
    calendar = Icalendar::Calendar.parse(cal_file).first
    return calendar
  end

  def save_calendar_events(calendar)
    last_event = 0
    calendar.events.each do |event|
      save_event(event)
    end
  end

  def save_event(calendar_event)
    event = Event.new
    event.calendar_id = calendar_event.uid
    event.start_time = calendar_event.dtstart
    event.end_time = calendar_event.dtend
    event.summary = calendar_event.summary
    event.link = nil 
    event.location = calendar_event.location
    event.hangout_link = nil
    unique_calendar_id = Event.distinct.pluck(:calendar_id)
    save_or_update_event(event, unique_calendar_id)
  end

  def save_or_update_event(event, unique_calendar_id)
    calendar_id_exists = unique_calendar_id.include?(event.calendar_id)
    if !calendar_id_exists
      event.save
      # trigger new event hooks here
    end
  end
end