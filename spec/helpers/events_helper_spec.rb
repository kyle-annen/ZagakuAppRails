require 'rails_helper'
include EventsHelper

RSpec.describe EventsHelper, type: :helper do
  describe 'mock_past_events' do
    it 'creates events in the past' do
      EventsHelper.mock_events(:past, 20)

      events = Event.all

      expect(events.count).to eq(20)

      events.each do |event|
        expect(event['start_time'].to_date).to be < Date.today
      end
    end
  end

  describe 'mock_upcoming_events' do
    it 'creates events in the past' do
      EventsHelper.mock_events(:upcoming, 20)

      events = Event.all

      expect(events.count).to eq(20)

      events.each do |event|
        expect(event['start_time'].to_date).to be > Date.today
      end
    end
  end

  describe 'mock_todays_event' do
    it 'creates event for today' do
      EventsHelper.mock_events(:today, 1)

      events = Event.all

      expect(events.count).to eq(1)

      events.each do |event|
        expect(event['start_time'].to_date).to eq(Date.today)
      end
    end
  end
end
