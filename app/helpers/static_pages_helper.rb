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
    description = event.summary.split(" - ")[2]
    day = event.start_time.strftime("%A")
    first_name_last_initial = event.summary.split(" - ")[1].split(" ")[0..1].join("-").downcase
    {day: day, description: description, presenter: first_name_last_initial[/^(\b)\w+../]}
  end

  def self.get_crafter_headshot_resources(image_urls)
    headshots = {}
    image_urls.each do |url|
      headshots.merge!(url.split("/")[-1].split("-")[0..1].join("-")[/^(\b)\w+../].to_sym => url)
    end
    headshots
  end

  def self.set_days_photo_location(day,headshots)
    presenter = day[:presenter]
    uri = headshots[presenter.to_sym]
    day.merge!(photo: uri)
  end

end
