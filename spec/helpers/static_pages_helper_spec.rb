require 'rails_helper'
include StaticPagesHelper
include MockEventsHelper

RSpec.describe StaticPagesHelper, type: :helper do
  describe '#get_week_details' do
    it 'returns a hash with the days of the week as keys' do
      VCR.use_cassette('8th_light_team') do
        team_photos = MetaInspector.new('https://8thlight.com/team/').images
        MockEventsHelper.mock_events(:upcoming, 4)
        events = Event.all
        helper = StaticPagesHelper.get_week_details(events,team_photos)
        expect(helper.length).to eq(4)
      end
    end
  end

  describe '#get_event_details' do
    it 'parses event details into hash containing the keys: day, description, presenter' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:upcoming, 1)
        events = Event.all
        parsed = StaticPagesHelper.get_event_details(events[0])
        expect(parsed[:day]).to eq(events[0].start_time.strftime("%A"))
      end
    end
  end

  describe '#get_crafter_headshot_resources' do
    it 'creates a hash with each crafters name as a key to their headshot' do
      VCR.use_cassette('8th_light_team') do
          image_urls = MetaInspector.new('https://8thlight.com/team/').images.to_a
          headshots = StaticPagesHelper.get_crafter_headshot_resources(image_urls)
          expect(headshots["scott-p".to_sym]).to eq('https://8thlight.com/images/team/scott-plunkett-ddda747d.jpg')
      end
    end
  end

  describe '#set_days_photo_location' do
    it 'merges headshots into days per days events presenter' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:upcoming, 4)
        headshots = StaticPagesHelper.get_crafter_headshot_resources(MetaInspector.new('https://8thlight.com/team/').images.to_a)
        events = Event.all
        day_before_merge = StaticPagesHelper.get_event_details(events[0])
        day = StaticPagesHelper.set_days_photo_location(day_before_merge,headshots)
        expect(day[:photo]).to include(day[:presenter])
      end
    end
  end
end
