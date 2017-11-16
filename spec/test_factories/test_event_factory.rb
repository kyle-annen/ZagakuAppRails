module TestEventFactory


  def generate_fake_events_in_db(nuber)
    start_date = DateTime.now - 1
    [*1..number].each do |number|
      test_event = Event.new
      test_event.calendar_id = number.to_s + "12345678sdhh389hlksd89@google.com"
      test_event.start_time = DateTime.now + number
      test_event.end_time = DateTime.now + number + 0.06
      test_event.summary = "Zagaku - " + 
                            Faker::Name.first_name + " " +
                            Faker::Name.last_name.first + " - " +
                            Faker::Hacker.ingverb + " " +
                            Faker::Hacker.adjective + " " +
                            Faker::Hacker.noun + " " +
                            Faker::Hacker.verb
      test_event.link = "https://caendar.com/" + number.to_s
      test_event.location = Faker::Address.street_name + "Conference Room"
      test_event.hanngout_link = "https://hantgouts.google.com/" + number.to_s
      test_event.save
    end
end