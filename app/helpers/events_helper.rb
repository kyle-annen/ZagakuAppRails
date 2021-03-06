module EventsHelper
  mon = 1
  tues = 2
  wed = 3
  thurs = 4
  fri = 5
  @working_days = [mon, tues, wed, thurs, fri]

  def get_events_by_week(date)
    date_event_hash = {}
    date.beginning_of_month.upto(date.end_of_month).each do |day|
      next unless @working_days.include?(day.wday)
      unless date_event_hash.keys.include?(day.cweek)
        date_event_hash[day.cweek] = {}
      end
      days_events = get_days_events(day)
      date_event_hash[day.cweek][day.wday] = days_events.empty? ? [] : days_events
    end
    date_event_hash
  end

  def get_days_events(date)
    Event.where('start_time BETWEEN ? AND ?',
                date.beginning_of_day,
                date.end_of_day)
  end

  def get_event_presenter(event)
    if event.summary.split(" - ").size > 1
     event.summary.split(" - ")[1].gsub(".","") 
    else
      ""
    end
  end

  def get_event_summary(event)
    if event.summary.split(" - ").size > 2
     event.summary.split(" - ")[2].gsub(".","") 
    else
      ""
    end
  end

  def is_zagaku_day?(date_given, week_number, day_number)
    if date_given.nil?
      false
    else
      date = Date.commercial(date_given.year, week_number, day_number)
      date >= Date.today && [1, 2, 3, 4].include?(day_number)
    end
  end
end
