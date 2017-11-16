require 'rails_helper'
include TestEventFactory

RSpec.describe TestEventFactory do
  describe 'generate_fake_events_in_db' do
    it 'creates the number of events indicated' do
      expected_event_count = 20

      TestEventFactory.generate_fake_events_in_db(expected_event_count)
      actual_event_count = Event.all.count
      expect(expected_event_count).to eq(actual_event_count)
    end

    it 'end time should be after start time' do
      TestEventFactory.generate_fake_events_in_db(1)
      event = Event.first

      expect(event.start_time).to be < event.end_time 
    end
  end
end