require 'rails_helper'
include GoogleCalendarService

RSpec.describe GoogleCalendarService do
  before(:each) do
    test_id = '123456789test123456789'
    test_event = instance_double('iCalendar',
                                 uid: test_id,
                                 dtstart: DateTime.now,
                                 dtend: DateTime.now,
                                 summary: 'A test event',
                                 link: 'http://testlink.com',
                                 location: 'Test Room',
                                 hangout_link: 'http://testhangout.com')
    allow(GoogleCalendarService)
      .to receive(:get_calendar_events)
      .and_return(events: [test_event])
  end

  after(:each) do
    Event.delete_all
  end

  describe 'sync_calendar_events' do
    it 'saves the calendar events' do
      Google
    end
  end

  describe 'save_event' do
    it 'saves an event to the calendar' do
      test_id = '123456789test123456789'
      test_event = instance_double('iCalendar',
                                   uid: test_id,
                                   dtstart: DateTime.now,
                                   dtend: DateTime.now,
                                   summary: 'A test event',
                                   link: 'http://testlink.com',
                                   location: 'Test Room',
                                   hangout_link: 'http://testhangout.com')

      GoogleCalendarService.save_event(test_event)

      saved_event = Event.where('calendar_id = ?', test_id)
      saved_id = saved_event.first.calendar_id

      expect(saved_id).to eq(test_id)
    end

    it 'does not update an event if calendar id exists and there is no event update' do
      test_id = '123456789test123456789'
      test_event = instance_double('iCalendar',
                                   uid: test_id,
                                   dtstart: DateTime.now,
                                   dtend: DateTime.now,
                                   summary: 'A test event is updated',
                                   link: 'http://testlink.com',
                                   location: 'Test Room',
                                   hangout_link: 'http://testhangout.com')

      GoogleCalendarService.save_event(test_event)
      GoogleCalendarService.save_event(test_event)

      test_records_count = Event.where('calendar_id = ?', test_id).count

      expect(test_records_count).to eq(1)
    end

    it 'updates an event if calendar id exists and there is no event update' do
      test_id = '123456789test123456789'
      time = DateTime.now
      test_event = instance_double('iCalendar',
                                   uid: test_id,
                                   dtstart: time,
                                   dtend: time,
                                   summary: 'A test event is updated',
                                   link: 'http://testlink.com',
                                   location: 'Test Room',
                                   hangout_link: 'http://testhangout.com')

      update_to_test_event = instance_double('iCalendar',
                                             uid: test_id,
                                             dtstart: time - 10.minutes,
                                             dtend: time,
                                             summary: 'A test event is updated',
                                             link: 'http://testlink.com',
                                             location: 'Test Room',
                                             hangout_link: 'http://testhangout.com')

      GoogleCalendarService.save_event(test_event)
      GoogleCalendarService.save_event(update_to_test_event)

      test_records_count = Event.where('calendar_id = ?', test_id).count
      updated_record = Event.where('calendar_id = ?', test_id)

      expect(test_records_count).to eq(1)
      expect(updated_record.first.start_time.utc).to eq((time - 10.minutes).utc)
    end
  end
end
