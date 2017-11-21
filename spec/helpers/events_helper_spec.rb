require 'rails_helper'
include EventsHelper

RSpec.describe EventsHelper, type: :helper do
  describe 'populate_past_mock_events_to_database' do
    it 'creates events in the past' do
      EventsHelper.populate_past_mock_events_to_database(20)

      events = Event.all

      expect(events.count).to eq(20)

      events.each do |event|
        expect(event['start_time'].to_date).to be < Date.today
      end
    end
  end

  describe 'populate_upcoming_mock_events_to_database' do
    it 'creates events in the past' do
      EventsHelper.populate_upcoming_mock_events_to_database(20)

      events = Event.all

      expect(events.count).to eq(20)

      events.each do |event|
        expect(event['start_time'].to_date).to be > Date.today
      end
    end
  end

  describe 'populate_mock_event_for_today' do
    it 'creates event for today' do
      EventsHelper.populate_mock_event_for_today

      events = Event.all

      expect(events.count).to eq(1)

      events.each do |event|
        expect(event['start_time'].to_date).to eq(Date.today)
      end
    end
  end
end
