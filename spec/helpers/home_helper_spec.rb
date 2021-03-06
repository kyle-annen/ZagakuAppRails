require 'rails_helper'
include HomeHelper
include MockEventsHelper

RSpec.describe HomeHelper, type: :helper do
  before(:each) do
    Event.delete_all
  end

  after(:each) do
    Event.delete_all
  end
  describe '#setup_preview_events' do
    it 'returns a hash of preview events' do
      VCR.use_cassette('8th_light_team') do
        team_photos = MetaInspector.new('https://8thlight.com/team/').images
        MockEventsHelper.mock_events(:upcoming, 4)
        events = Event.all
        helper = HomeHelper.setup_preview_events(events,team_photos)
        expect(helper.length).to eq(4)
      end
    end
  end

  describe '#get_event_details' do
    it 'parses event details into hash containing the keys: day, description, presenter' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:upcoming, 1)
        events = Event.all
        parsed = HomeHelper.get_event_details(events[0])
        expect(parsed[:weekday]).to eq(events[0].start_time.strftime("%A"))
        expect(parsed[:starts]).to eq(events[0].start_time.strftime("%l:%M %p"))
        expect(parsed[:month_day]).to eq(events[0].start_time.strftime("%b. %d"))
      end
    end
  end

  describe '#fetch_presenter_from_event_summary' do
    it 'returns the presenter from an event summary' do
      VCR.use_cassette('8th_light_team') do
          summary = "Zagaku - Kevin K. - Indexing Neural Capacitor Compress"
          presenter = "Kevin K."
          fetched_presenter = HomeHelper.fetch_presenter_from_event_summary(summary)
          expect(fetched_presenter).to eq(presenter)
      end
    end
  end

  describe '#get_crafter_headshot_resources' do
    it 'creates a hash with each crafters name as a key to their headshot' do
      VCR.use_cassette('8th_light_team') do
          image_urls = MetaInspector.new('https://8thlight.com/team/').images.to_a
          headshots = HomeHelper.get_crafter_headshot_resources(image_urls)
          expect(headshots["scott-p".to_sym]).to eq('https://8thlight.com/images/team/scott-plunkett-ddda747d.jpg')
      end
    end
  end

  describe '#match_presenter_to_photo_location' do
    it 'merges headshots into days per days events presenter' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:upcoming, 4)
        headshots = HomeHelper.get_crafter_headshot_resources(MetaInspector.new('https://8thlight.com/team/').images.to_a)
        events = Event.all
        day_before_merge = HomeHelper.get_event_details(events[0])
        day = HomeHelper.match_presenter_to_photo_location(day_before_merge,headshots)
        expect(day[:photo]).to include(day[:presenter].split(" ")[0..1].join("-").downcase[/^(\b)\w+../])
      end
    end
  end
end
