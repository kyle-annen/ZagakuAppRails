require 'rails_helper'

RSpec.describe GoogleCalendarController, type: :controller do
  describe 'get_calendar_events' do
    it 'saves events to the database' do
      sut = GoogleCalendarController.new
      cal = sut.get_calendar_events
      sut.save_cal_events(cal)
      expect(Event.first).to be_present 
    end
  end
end