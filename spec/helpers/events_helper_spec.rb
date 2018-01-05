require 'rails_helper'
include EventsHelper

RSpec.describe EventsHelper, type: :helper do
  before(:each) do
    Event.delete_all
    MockEventsHelper.mock_events(:past, 100)
    MockEventsHelper.mock_events(:upcoming, 30)
    MockEventsHelper.mock_events(:today, 1)
  end

  after(:each) do
    Event.delete_all
  end

  describe 'todays_events' do
    it 'returns the one event scheduled for the date given' do
      result = EventsHelper.get_days_events(Date.today)
      expect(result.size).to eq(1)
      expect(result.first.start_time.to_date).to eq(Date.today)
    end
  end

  describe 'get_events_by_week' do
    it 'returns an hash with week numbers as keys' do
      result = EventsHelper.get_events_by_week(Date.today)
      expect(result.keys).to include(Date.today.cweek)
    end

    it 'returns a hash of hashes for the day number, when no day number is 0, 5, or 6' do
      result = EventsHelper.get_events_by_week(Date.today)
      result.keys.each do |key|
        expect(result[key].keys).not_to include(0, 6)
      end
    end
  end

  describe 'get_event_presenter' do
    it 'gets the presenter name when it exists' do
      Event.create(start_time: Time.now,
                   end_time: Time.now,
                   summary: 'Zagaku - Franklin R. - Swift Algebraic Types',
                   link: '',
                   location: 'Wabash Conference Room',
                   hangout_link: '')

      result = EventsHelper.get_event_presenter(Event.last)

      expect(result).to eq('Franklin R')
    end

    it 'returns an empty string if there is no presenter name' do
      Event.create(start_time: Time.now,
                   end_time: Time.now,
                   summary: 'Zagaku To Be Determined',
                   link: '',
                   location: 'Wabash Conference Room',
                   hangout_link: '')

      result = EventsHelper.get_event_presenter(Event.last)

      expect(result).to eq('')
    end
  end

  describe 'get_event_summary' do
    it 'gets the summary when it exists' do
      Event.create(start_time: Time.now,
                   end_time: Time.now,
                   summary: 'Zagaku - Franklin R. - Swift Algebraic Types',
                   link: '',
                   location: 'Wabash Conference Room',
                   hangout_link: '')

      result = EventsHelper.get_event_summary(Event.last)

      expect(result).to eq('Swift Algebraic Types')
    end

    it 'returns an empty string if there is no summary' do
      Event.create(start_time: Time.now,
                   end_time: Time.now,
                   summary: 'Zagaku To Be Determined',
                   link: '',
                   location: 'Wabash Conference Room',
                   hangout_link: '')

      result = EventsHelper.get_event_summary(Event.last)

      expect(result).to eq('')
    end
  end

  describe 'is_zagaku_day' do
    it 'returns true if the date is a zagaku day (M,T,W,T)' do

      [1,2,3,4].each do |day|
        non_zagaku_day = Date.commercial(2017, 2, day)
        expect(EventsHelper.is_zagaku_day?(non_zagaku_day, 2, day)).to eq(false)
      end

      [5,6,7].each do |day|
        non_zagaku_day = Date.commercial(2017, 2, day)
        expect(EventsHelper.is_zagaku_day?(non_zagaku_day, 2, day)).to eq(false)
      end
    end

    it 'returns false if date_given is nil' do
      expect(EventsHelper.is_zagaku_day?(
          nil,
          1,
          1)
      ).to eq(false)
    end
  end
end
