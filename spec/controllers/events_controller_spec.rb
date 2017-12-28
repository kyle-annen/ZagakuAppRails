require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET #index' do
    it 'renders the index' do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    it 'redirects to google calendar event creation' do
      post :create, params: {
        first_name: 'Test',
        last_name: 'test',
        date: Date.new(2017, 12, 27).to_s,
        talk_title: 'Test Title',
        location: 'Wabash',
        summary: 'short test summary',
        time_zone: 'America/Chicago',
        start_time: ['10:00'],
        end_time: ['10:15']
      }
      expect(response).to redirect_to("https://calendar.google.com/calendar/r/eventedit?action=TEMPLATE&text=Zagaku+-+Test t.+-+Test Title&dates=20171227T040000Z/20171227T041500Z&location=Wabash&src=8thlight.com_2lmksu0derpihviusb1ml7hca4@group.calendar.google.com&output=xml&sf=true&details=short test summary")
    end
  end
end
