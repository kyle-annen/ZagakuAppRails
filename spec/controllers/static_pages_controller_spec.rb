require 'rails_helper'
include StaticPagesHelper

RSpec.describe StaticPagesController, type: :controller do
  before(:each) do
    Event.delete_all
  end

  after(:each) do
    Event.delete_all
  end

  describe 'Get #index' do
    it 'has preview events' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:upcoming, 4)
        get :index
        expect(controller.instance_variable_get(:@preview_events).length).to eq(3)
      end
    end
  end

  describe '#team_photos' do
    it 'returns array of 8th Light team image URLs' do
      VCR.use_cassette('8th_light_team') do
        @controller = StaticPagesController.new
        photos = @controller.instance_eval { team_photos }
        expect(photos.class).to be(Array)
        photos.all? do |photo|
          expect(photo).to end_with('.jpg').or end_with('.png')
        end
      end
    end
  end

  describe '#upcoming_events' do
    it 'returns upcoming events with their metadata' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:this_week, 5)
        @controller = StaticPagesController.new
        @controller.instance_eval { upcoming_events }.all? do |event|
          expect(event).to have_attributes(summary: String)
        end
      end
    end

    describe '#set_preview_events' do
      it 'returns the preview events with details parsed into a hash' do
        VCR.use_cassette('8th_light_team') do
          MockEventsHelper.mock_events(:this_week, 5)
          @controller = StaticPagesController.new
          @controller.instance_eval { set_preview_events }.all? do |day|
            expect(day[:photo]).to include(
              day[:presenter].split(' ')[0..1]
                  .join('-').downcase[/^(\b)\w+../]
            )
          end
        end
      end
    end
  end
  describe '#set_preview_topics' do
    it 'returns the preview topics parsed into a hash' do
      VCR.use_cassette('8th_light_team') do
        User.create(
          email: 'test@test.com',
          password: Devise.friendly_token[0, 20],
          first_name: 'test',
          last_name: 'test'
        )

        sign_in(User.first)

        Category.create(category: 'test')
                .topics.create(name: 'test.md')
                .topic_levels.create(level_number: 1)
                .tasks.create(content: 'test content')

        UserTask.create(task_id: Task.first[:id],
                        user_id: User.first[:id])

        get :index

        expect(assigns[:preview_topics].first[:id]).to eq(Topic.first[:id])
        expect(assigns[:preview_topics].first[:name]).to eq('Test')
        expect(assigns[:preview_topics].first[:percent_complete]).to eq('0%')
      end
    end
  end
end
