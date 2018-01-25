require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before(:each) do
    User.delete_all
    Calendar.delete_all
    Event.delete_all
  end

  after(:each) do
    User.delete_all
    Calendar.delete_all
    Event.delete_all
  end

  describe 'GET #index' do
    it 'renders the index if user is employee' do
      User.create(email: 'test@8thlight.com',
                  password: Devise.friendly_token[0, 20],
                  first_name: 'test',
                  last_name: 'test')

      sign_in User.first

      get :index

      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    it 'redirects to google calendar event creation' do
      User.create(email: 'test@8thlight.com',
                  password: Devise.friendly_token[0, 20],
                  first_name: 'test',
                  last_name: 'test')

      sign_in User.first

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
      expect(response).to redirect_to('https://calendar.google.com/calendar/r/eventedit?action=TEMPLATE&text=Zagaku+-+Test t.+-+Test Title&dates=20171227T040000Z/20171227T041500Z&location=Wabash&src=8thlight.com_2lmksu0derpihviusb1ml7hca4@group.calendar.google.com&output=xml&sf=true&details=short test summary')
    end
  end

  describe 'before action :require_employee' do
    it 'calendar page is not viewable by non-employee' do
      User.create(email: 'test@8thlight.comx',
                  password: Devise.friendly_token[0, 20],
                  first_name: 'test',
                  last_name: 'test')

      sign_in User.first

      get :index

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'calendar selection' do
    it 'defaults to the first calendar' do
      User.create(email: 'test@8thlight.com',
                  password: Devise.friendly_token[0, 20],
                  first_name: 'test',
                  last_name: 'test')

      sign_in User.first

      calendar = Calendar.create(name: 'Test',
                                 google_ical_link: 'testlink',
                                 time_zone: ActiveSupport::TimeZone.all.first)

      calendar.events.create(calendar_uid: 'test',
                             start_time: DateTime.now,
                             end_time: DateTime.now,
                             summary: 'test',
                             link: 'test',
                             location: 'test',
                             hangout_link: 'test')

      get :index

      expect(controller.instance_variable_get(:@calendar)).to eq(calendar)
    end

    it 'loads the preferred calendar of the user' do
      Calendar.delete_all
      Event.delete_all
      User.delete_all

      user = User.create(email: 'test@8thlight.com',
                  password: Devise.friendly_token[0, 20],
                  first_name: 'test',
                  last_name: 'test')

      sign_in user

      calendar = Calendar.create(name: 'Test',
                                 google_ical_link: 'testlink',
                                 time_zone: ActiveSupport::TimeZone.all.first)

      calendar.events.create(calendar_uid: 'test',
                             start_time: DateTime.now,
                             end_time: DateTime.now,
                             summary: 'test',
                             link: 'test',
                             location: 'test',
                             hangout_link: 'test')

      calendar2 = Calendar.create(name: 'Test2',
                                 google_ical_link: 'testlinkasdfasf',
                                 time_zone: ActiveSupport::TimeZone.all.first)

      calendar2.events.create(calendar_uid: 'test2',
                             start_time: DateTime.now,
                             end_time: DateTime.now,
                             summary: 'test',
                             link: 'test',
                             location: 'test',
                             hangout_link: 'test')

      user.update(preferred_calendar: calendar2.id)

      get :index

      expect(controller.instance_variable_get(:@calendar)).to eq(calendar2)
    end
  end
end
