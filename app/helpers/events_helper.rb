module EventsHelper
  @strategy = {
    past: -> { Faker::Time.backward(100, :morning) - 1 },
    upcoming: -> { Faker::Time.forward(30, :morning) },
    today: -> { Faker::Time.between(Date.today, Date.today, :morning) }
  }

  def mock_events(strategy, quantity)
    random_number = lambda { |x| Faker::Number.between(1, x) }

    quantity.times do
      event = Event.new
      event.calendar_id = Faker::Crypto.md5 + '@google.com'
      event.start_time = @strategy[strategy].call
      event.end_time = event.start_time
      event.summary = get_mock_summary
      event.link = Faker::Internet.url
      event.location = Faker::Address.community
      event.hangout_link = Faker::Internet.url
      event.created_at = event.start_time - random_number.call(30)
      event.updated_at = event.created_at + random_number.call(4)
      event.save
    end
  end

  private

  def get_mock_summary
    category = 'Zagaku'
    name = Faker::Name.first_name + ' ' + Faker::Name.last_name.first
    topic = [
      Faker::Hacker.ingverb,
      Faker::Hacker.adjective,
      Faker::Hacker.noun,
      Faker::Hacker.verb
    ].join(' ').titlecase
    [category, name, topic].join(' - ')
  end
end
