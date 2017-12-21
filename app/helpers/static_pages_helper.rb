module StaticPagesHelper
  def self.get_week_details(events,image_urls)
    this_week = []
    headshots = get_crafter_headshot_resources(image_urls)
    events.each do |event|
      this_week << get_event_details(event)
    end
    this_week.each do |day|
      set_days_photo_location(day,headshots)
    end
    this_week
  end

  def self.get_event_details(event)
    Time.zone = "America/Chicago"
    scheduled_start = event.start_time.in_time_zone
    date = scheduled_start.strftime("%b. %d")
    time = scheduled_start.strftime("%l:%M %p")
    day = scheduled_start.strftime("%A")
    description = event.summary.split(" - ")[2]
    first_name_last_initial = fetch_presenter_from_event_summary(event.summary)
    {weekday: day, starts: time, month_day: date, description: description, presenter: first_name_last_initial}
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

  def self.set_days_photo_location(day,headshots)
    presenter = day[:presenter].split(" ")[0..1].join("-").downcase[/^(\b)\w+../]
    uri = headshots[presenter.to_sym]
    day.merge!(photo: uri)
  end

end
