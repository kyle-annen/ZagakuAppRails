require 'rails_helper'
include StaticPagesHelper
include EventsHelper

RSpec.describe StaticPagesController, type: :controller do

  describe 'Get #index' do
    it 'has preview events' do
      VCR.use_cassette('8th_light_team') do
        EventsHelper.mock_events(:previews, 5)
        get :index
        expect(response).to render_template(:index)
        expect(controller.instance_variable_get(:@preview_events).length).to eq(3)
      end
    end
  end

  describe '#team_photos' do
    it 'returns array of 8th Light team image URLs' do
      VCR.use_cassette('8th_light_team') do
        @controller = StaticPagesController.new
        photos = @controller.instance_eval{ team_photos }
        expect(photos.class).to be(Array)
        photos.all? do |photo|
          expect(photo).to end_with(".jpg").or end_with(".png")
        end
      end
    end
  end

  describe '#upcoming_events' do
    it 'returns upcoming events with their metadata' do
      VCR.use_cassette('8th_light_team') do
        EventsHelper.mock_events(:previews, 5)
        @controller = StaticPagesController.new
        @controller.instance_eval{ upcoming_events }.all? do |event|
        expect(event).to have_attributes(summary: String)
        end
      end
    end

    describe '#set_preview_events' do
      it 'returns the preview events with details parsed into a hash' do
        VCR.use_cassette('8th_light_team') do
          EventsHelper.mock_events(:previews, 5)
          @controller = StaticPagesController.new
          @controller.instance_eval{ set_preview_events }.all? do |day|
            expect(day[:photo]).to include(day[:presenter].split(" ")[0..1].join("-").downcase[/^(\b)\w+../])
          end
        end
      end
    end
  end
end


