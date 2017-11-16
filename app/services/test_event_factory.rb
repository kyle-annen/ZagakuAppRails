module TestEventFactory
  def generate_fake_events_in_db(number_of_events)
    start_date = DateTime.now - 1
    offset = 0
    valid_days = [1,2,3,4]
    meeting_end_time_offset = 0.06

    [*1..number_of_events].each do |number|
      while !valid_days.include? (start_date + number + offset).to_date.wday do
        offset += 1
      end 
      test_event = Event.new
      test_event.calendar_id = number.to_s + "12345678sdhh389hlksd89@google.com"
      test_event.start_time = start_date + number
      test_event.end_time = start_date + number + meeting_end_time_offset
      test_event.summary = "Zagaku - " + 
                            Faker::Name.first_name + " " +
                            Faker::Name.last_name.first + " - " +
                            Faker::Hacker.ingverb.titlecase + " " +
                            Faker::Hacker.adjective.titlecase + " " +
                            Faker::Hacker.noun.titlecase + " " +
                            Faker::Hacker.ingverb.titlecase
      test_event.link = "https://caendar.com/" + number.to_s
      test_event.location = Faker::Address.street_name + "Conference Room"
      test_event.hangout_link = "https://hantgouts.google.com/" + number.to_s
      test_event.save
    end
  end
end