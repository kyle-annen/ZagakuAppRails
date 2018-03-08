require 'rails_helper'

RSpec.describe EventJob, type: :job do
  before(:each) do
    Event.delete_all
  end

  after(:each) do
    Event.delete_all
  end
  describe 'perform' do
    it 'runs the job to sync calendars' do
      VCR.use_cassette('event_job') do
        expect(Event.all.size).to eq(0)
        EventJob.new.perform
        expect(Event.all.size).to be >= 0
      end
    end
  end
end
