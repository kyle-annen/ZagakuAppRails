# frozen_string_literal: true

module EventsHelper
  @working_days = [1, 2, 3, 4, 5]

  def get_events_by_week(date, calendar)
    hash = {}
    date_range = Array(date.beginning_of_month..date.end_of_month)
    start_datetime = date.beginning_of_month.beginning_of_day
    end_datetime = date.end_of_month.end_of_day
    events = months_events(calendar, end_datetime, start_datetime)
    create_date_hash_keys(hash, date_range)
    events.each do |event|
        add_event_to_nested_hash(event, hash)
    end
    hash
  end

  def get_days_events(date, calendar)
    calendar.events.where('start_time BETWEEN ? AND ?',
                          date.beginning_of_day,
                          date.end_of_day)
  end

  def get_event_presenter(event)
    if event.summary.split(' - ').size > 1
      event.summary.split(' - ')[1].delete('.')
    else
      ''
    end
  end

  def get_event_summary(event)
    if event.summary.split(' - ').size > 2
      event.summary.split(' - ')[2].delete('.')
    else
      ''
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

  private

  def months_events(calendar, end_datetime, start_datetime)
    Event.where(calendar_id: calendar.id)
         .where('start_time >= ? AND start_time <= ?',
                start_datetime,
                end_datetime)
  end

  def create_date_hash_keys(hash, date_range)
    date_range.each do |date|
      day = date.wday
      week = date.cweek
      if @working_days.include?(day)
        hash[week] = {} unless hash.key?(week)
        hash[week][day] = [] unless hash[week].key?(day)
      end
    end
  end

  def add_event_to_nested_hash(event, hash)
    if @working_days.include?(event[:start_time].to_date.wday)
      week_number = event[:start_time].to_date.cweek
      day_number = event[:start_time].to_date.wday
      hash[week_number][day_number].append(event)
    end
  end
end
