class GoogleCalendarController < ApplicationController

  def index
    cal_events = get_calendar_events
    save_cal_events(cal_events)
    @upcoming_events = Event.where('start_time > ?', DateTime.now).order('start_time asc')
  end

  def get_calendar_events
    cal_file = open(ENV['GOOGLE_ICAL_LINK']) { |f| f.read }
    calendar = Icalendar::Calendar.parse(cal_file).first
    return calendar
  end

  def save_cal_events(calendar)
    last_event = 0
    calendar.events.each do |event|
      save_event(event)
    end
  end

  def save_event(calendar_event)
    event = Event.new
    event.calendar_id  = calendar_event.uid
    event.start_time = calendar_event.dtstart
    event.summary = calendar_event.summary
    event.link = nil 
    event.location = calendar_event.location
    event.hangout_link = calendar_event = nil

    if Event.where('calendar_id = ?', event.calendar_id).exists? == false 
      event.save
    end
  end
end