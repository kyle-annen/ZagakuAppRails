require 'rails_helper'
include GoogleCalendarService

RSpec.describe GoogleCalendarService do
  describe 'sync_calendar' do
    it 'saves events to the database' do
      EventsHelper.sync_calendar
      expect(Event.first).to be_present 
    end
  end

  describe 'save_event' do
    it 'saves an event to the calendar' do
      test_id = "123456789test123456789"
      test_event = instance_double("iCalendar", 
        :uid => test_id,
        :dtstart => DateTime.now,
        :dtend => DateTime.now,
        :summary => "A test event",
        :link => "http://testlink.com",
        :location => "Test Room",
        :hangout_link => "http://testhangout.com",
      )

      EventsHelper.save_event(test_event)

      saved_event = Event.where('calendar_id = ?', test_id)
      saved_id = saved_event.first.calendar_id

      expect(saved_id).to eq(test_id)

    end

  it 'does not save an event if calendar id exists' do
      test_id = "123456789test123456789"
      test_event = instance_double("iCalendar", 
        :uid => test_id,
        :dtstart => DateTime.now,
        :dtend => DateTime.now,
        :summary => "A test event",
        :link => "http://testlink.com",
        :location => "Test Room",
        :hangout_link => "http://testhangout.com",
      )

      EventsHelper.save_event(test_event)
      EventsHelper.save_event(test_event)

      test_records_count = Event.where('calendar_id = ?', test_id).count

      expect(test_records_count).to eq(1)
    end
  end

end