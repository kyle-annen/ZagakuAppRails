require 'rails_helper'
include GoogleCalendarService

RSpec.describe EventApiController, type: :controller do
  before(:each) do
    Event.delete_all
    MockEventsHelper.mock_events(:past, 25)
    MockEventsHelper.mock_events(:upcoming, 20)
    MockEventsHelper.mock_events(:today, 1)
  end

  after(:each) do
    Event.delete_all
  end

  describe 'GET #index' do
    it '/api/events routes to events_api#index' do
      expect(get: '/api/events?time_period=upcoming').to route_to(
        controller: 'event_api',
        action: 'index',
        time_period: 'upcoming'
      )
    end

    it 'when passed upcoming time-frame, return dates greater than today' do
      get :index, params: { time_period: 'upcoming' }
      json = JSON.parse(response.body)

      expect(json.count).to eq(21)

      json.each do |event|
        expect(event['start_time'].to_date).to be >= Date.today
      end
    end

    it 'when time frame is past, returns events in the past' do
      get :index, params: { time_period: 'past' }
      json = JSON.parse(response.body)

      expect(json.count).to eq(25)

      json.each do |event|
        expect(event['start_time'].to_date).to be < Date.today
      end
    end

    it 'when time frame is past, returns events in the past' do
      get :index, params: { time_period: 'all' }
      json = JSON.parse(response.body)
      expect(json.count).to eq(46)
      expect(json.size).to be > 0
    end

    it 'returns error when time_period is not passed' do
      get :index, params: {}
      json = JSON.parse(response.body)
      expect(json).to eq('error' => 'Valid time period required.')
    end

    it 'returns error when incorrect time period is passed' do
      get :index, params: { time_period: 'tubular-future'}
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Valid time period required.')
    end
  end
end
