module GoogleCalendarService
  def sync_calendar
    Event.delete_all
    calendar = get_calendar_events
    save_calendar_events(calendar)
  end

  def get_calendar_events
    cal_file = open(ENV['GOOGLE_ICAL_LINK'], &:read)
    Icalendar::Calendar.parse(cal_file).first
  end

  def save_calendar_events(calendar)
    calendar.events.each do |event|
      save_event(event)
    end
  end

  def save_event(calendar_event)
    uid = calendar_event.uid.to_s
    event_exists = !Event.where(calendar_id: uid).empty?
    event = event_exists ? Event.where(calendar_id: uid).first : Event.new
    event.calendar_id = calendar_event.uid
    event.start_time = calendar_event.dtstart
    event.end_time = calendar_event.dtend
    event.summary = calendar_event.summary
    event.link = nil
    event.location = calendar_event.location
    event.hangout_link = nil
    event.save
  end
end
