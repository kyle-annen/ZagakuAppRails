module HomeHelper
  include LearningTrailsHelper
  def self.task_completion_percentage(topic, user)
    LearningTrailsHelper.task_completion_percentage(topic, user)
  end

  def self.setup_preview_events(events,image_urls)
    preview_events = []
    headshots = get_crafter_headshot_resources(image_urls)
    events.each do |event|
      preview_events << get_event_details(event)
    end
    preview_events.each do |event|
      match_presenter_to_photo_location(event,headshots)
    end
    preview_events
  end

  def self.get_event_details(event)
    Time.zone = "America/Chicago"
    calendar_api_starttime = event.start_time.strftime("%Y%m%dT%H%M")
    calendar_api_endtime = event.end_time.strftime("%Y%m%dT%H%M")
    scheduled_start = event.start_time.in_time_zone
    scheduled_end = event.end_time.in_time_zone
    date = scheduled_start.strftime("%b. %d")
    time = scheduled_start.strftime("%l:%M %p")
    day = scheduled_start.strftime("%A")
    description = event.summary.split(" - ")[2]
    first_name_last_initial = fetch_presenter_from_event_summary(event.summary)
    { weekday: day,
      starts: time,
      month_day: date,
      description: description,
      presenter: first_name_last_initial,
      google_calendar_add_event_path: google_cal_add_url(event.summary,
                                                         scheduled_start,
                                                         scheduled_end,
                                                         description,
                                                         event.location).gsub(" ", "+") }
  end

  def self.fetch_presenter_from_event_summary(summary)
    presenter = summary.split("-")[1].strip.titlecase
  end

  def self.get_crafter_headshot_resources(image_urls)
    headshots = {}
    image_urls.each do |url|
      headshots.merge!(url.split("/")[-1].split("-")[0..1].join("-")[/^(\b)\w+../].to_sym => url)
    end
    headshots
  end

  def self.match_presenter_to_photo_location(day,headshots)
    presenter = day[:presenter].split(" ")[0..1].join("-").downcase[/^(\b)\w+../]
    uri = headshots[presenter.to_sym]
    day.merge!(photo: uri)
  end

  def self.google_cal_add_url(summary,start,finish,description,location)
    "https://www.google.com/calendar/render?action=TEMPLATE" +
    "&text=" + summary +
    "&dates=" + start.strftime("%Y%m%eT%I%M%S") + "/" + finish.strftime("%Y%m%eT%I%M%S") +
    "&details=" + description +
    "&location=" + "25+E+Washington+St+Chicago+IL" + location +
    "&sprop=name:Name&sprop=website:www.8thlight.com&sf=true&output=xml"
  end
end
