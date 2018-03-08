module GoogleCalendarService
  def sync_calendar()
    Event.delete_all
    
    Calendar.all.each do |calendar|
      calendar_events = get_calendar_events(calendar)
      save_calendar_events(calendar_events, calendar)
    end
  end

  def get_calendar_events(calendar)
    cal_file = open(calendar.google_ical_link, &:read)
    Icalendar::Calendar.parse(cal_file).first
  end

  def save_calendar_events(calendar_events, calendar)
    calendar_events.events.each do |event|
      save_event(event, calendar)
    end
  end

  def save_event(calendar_event, calendar)
    uid = calendar_event.uid.to_s
    event_exists = !Event.where(calendar_uid: uid).empty?
    event = event_exists ? calendar.events.where(calendar_uid: uid).first : calendar.events.new
    event.calendar_uid = calendar_event.uid
    event.start_time = calendar_event.dtstart
    event.end_time = calendar_event.dtend
    event.summary = calendar_event.summary
    event.link = nil
    event.location = calendar_event.location
    event.hangout_link = nil
    event.save
  end
end
