# include GoogleCalendarService

module EventsHelper
  def populate_past_mock_events_to_database(number)
    number.times do |i|
      event = Event.new
      event.calendar_id = Faker::Crypto.md5 + "@google.com"
      event.start_time = Faker::Time.backward(100, :morning) - 1
      event.end_time = event.start_time + 0.04
      event.summary = "Zagaku - " + 
        Faker::Name.first_name + 
        " " + 
        Faker::Name.last_name.first +
        " - " +
        [Faker::Hacker.ingverb, Faker::Hacker.adjective, 
        Faker::Hacker.noun, Faker::Hacker.verb].join(" ").titlecase
      event.link = Faker::Internet.url
      event.location = 
      event.hangout_link = 
      event.created_at = event.start_time - Faker::Number.between(1, 30)
      event.updated_at = event.created_at + Faker::Number.between(1,4)
      event.save
    end
  end

  def populate_upcoming_mock_events_to_database(number)
    number.times do |i|
      event = Event.new
      event.calendar_id = Faker::Crypto.md5 + "@google.com"
      event.start_time = Faker::Time.forward(30, :morning)
      event.end_time = event.start_time + 0.04
      event.summary = "Zagaku - " + 
        Faker::Name.first_name + 
        " " + 
        Faker::Name.last_name.first +
        " - " +
        [Faker::Hacker.ingverb, Faker::Hacker.adjective, 
        Faker::Hacker.noun, Faker::Hacker.verb].join(" ").titlecase
      event.link = Faker::Internet.url
      event.location = 
      event.hangout_link = 
      event.created_at = event.start_time - Faker::Number.between(1, 30)
      event.updated_at = event.created_at + Faker::Number.between(1,4)
      event.save
    end
  end

  def populate_mock_event_for_today
    event = Event.new
    event.calendar_id = Faker::Crypto.md5 + "@google.com"
    event.start_time = Faker::Time.between(Date.today, Date.today, :morning)
    event.end_time = event.start_time + 0.04
    event.summary = "Zagaku - " + 
      Faker::Name.first_name + 
      " " + 
      Faker::Name.last_name.first +
      " - " +
      [Faker::Hacker.ingverb, Faker::Hacker.adjective, 
      Faker::Hacker.noun, Faker::Hacker.verb].join(" ").titlecase
    event.link = Faker::Internet.url
    event.location = 
    event.hangout_link = 
    event.created_at = event.start_time - Faker::Number.between(1, 30)
    event.updated_at = event.created_at + Faker::Number.between(1,4)
    event.save
  end
end
