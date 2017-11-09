require 'rails_helper'

RSpec.describe GoogleCalendarController, type: :controller do
  describe 'update_zagaku_data' do
    it 'returns stuff' do
      gCalController = GoogleCalendarController.new()
      # gCalController.update_zagaku_data
      expect(true)
    end
  end


  describe 'update_zagaku_events' do
    it 'updates zagaku events' do
      expect(true)
    end
  end

end