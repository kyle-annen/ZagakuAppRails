require 'rails_helper'
include GoogleCalendarService

RSpec.describe GoogleCalendarService do
  before(:each) do
    Event.delete_all
    test_id = '123456789test123456789'
    test_event = instance_double('iCalendar',
                                 uid: test_id,
                                 dtstart: DateTime.now,
                                 dtend: DateTime.now,
                                 summary: 'A test event',
                                 link: 'http://testlink.com',
                                 location: 'Test Room',
                                 hangout_link: 'http://testhangout.com')

    Calendar.create(google_ical_link: ENV['GOOGLE_ICAL_LINK'],
                    name: 'test-name',
                    time_zone: ActiveSupport::TimeZone.all.first)

    allow(GoogleCalendarService)
      .to receive(:get_calendar_events)
      .and_return(events: [test_event])
  end

  after(:each) do
    Event.delete_all
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

      calendar = Calendar.first
      GoogleCalendarService.save_event(test_event, calendar)

      saved_event = Event.where('calendar_uid = ?', test_id)
      saved_id = saved_event.first.calendar_uid

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

      calendar = Calendar.first
      GoogleCalendarService.save_event(test_event, calendar)
      GoogleCalendarService.save_event(test_event, calendar)

      test_records_count = Event.where('calendar_uid = ?', test_id).count

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

      calendar = Calendar.first
      GoogleCalendarService.save_event(test_event, calendar)
      ap Event.all
      GoogleCalendarService.save_event(update_to_test_event, calendar)
      ap Event.all

      test_records_count = Event.where('calendar_uid = ?', test_id).count
      updated_record = Event.where('calendar_uid = ?', test_id)

      expect(test_records_count).to eq(1)
      hour = updated_record.first.start_time.utc.hour
      min = updated_record.first.start_time.utc.min
      sec = updated_record.first.start_time.utc.sec
      expect(hour).to eq((time - 10.minutes).utc.hour)
      expect(min).to eq((time - 10.minutes).utc.min)
      expect(sec).to eq((time - 10.minutes).utc.sec)
    end
  end
end
