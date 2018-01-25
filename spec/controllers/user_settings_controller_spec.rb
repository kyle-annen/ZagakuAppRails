require 'rails_helper'

RSpec.describe UserSettingsController, type: :controller do
  before(:each) do
    Calendar.delete_all
    User.delete_all
  end

  after(:each) do
    Calendar.delete_all
    User.delete_all
  end

  describe 'update user' do
    it 'updates the user information' do
      user = User.create(email: 'test@8thlight.com',
                         password: Devise.friendly_token[0, 20],
                         first_name: 'test',
                         last_name: 'test')

      calendar = Calendar.create(name: 'Test',
                                 google_ical_link: 'testlink',
                                 time_zone: ActiveSupport::TimeZone.all.first)

      sign_in(user)

      post :update, params: {
        user_id: user.id,
        email: 'changed@email.com',
        first_name: user.first_name,
        last_name: user.last_name,
        preferred_calendar: calendar.id
      }

      updated_user = User.find(user.id)
      expect(updated_user.preferred_calendar).to eq(calendar.id)
      expect(updated_user.email).to eq('changed@email.com')
    end
  end
end
