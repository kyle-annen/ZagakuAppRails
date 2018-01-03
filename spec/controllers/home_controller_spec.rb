require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before(:each) do
    Event.delete_all
  end

  after(:each) do
    Event.delete_all
  end

  describe 'Get #index' do
    it 'has preview events' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:upcoming, 10)
        get :index
        expect(response).to render_template(:index)
        expect(controller.instance_variable_get(:@upcoming).length).to eq(4)
      end
    end
    it 'has preview events' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:this_week, 4)
        get :index
        expect(controller.instance_variable_get(:@this_week).length).to eq(4)
      end
    end
  end

  describe '#team_photos' do
    it 'returns array of 8th Light team image URLs' do
      VCR.use_cassette('8th_light_team') do
        @controller = HomeController.new
        photos = @controller.instance_eval { team_photos }
        expect(photos.class).to be(Array)
        photos.all? do |photo|
          expect(photo).to end_with('.jpg').or end_with('.png')
        end
      end
    end
  end

  describe '#future_events' do
    it 'returns future events with their metadata' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:upcoming, 5)
        @controller = HomeController.new
        @controller.instance_eval { future_events }.all? do |event|
          expect(event).to have_attributes(summary: String)
          expect(event[:start_time]).to be > (Time.current - 1.day)
        end
      end
    end
  end

  describe '#events_this_week' do
    it 'returns this weeks events with their metadata' do
      VCR.use_cassette('8th_light_team') do
        MockEventsHelper.mock_events(:this_week, 5)
        @controller = HomeController.new
        @controller.instance_eval { events_this_week }.all? do |event|
          expect(event).to have_attributes(summary: String)
          expect(event[:start_time]).to be > (Time.current.beginning_of_week - 1.day)
          expect(event[:start_time]).to be < (Time.current.end_of_week + 1.day)
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

    it 'has suggested learning trails when the total user task is not equal to 5' do
      VCR.use_cassette('8th_light_team') do
        User.create(
          email: 'test@test.com',
          password: Devise.friendly_token[0, 20],
          first_name: 'test',
          last_name: 'test'
        )

        sign_in(User.first)

        i = 0
        10.times do
          Category.create(category: "test#{i}")
          .topics.create(name: "test#{i}.md")
          .topic_levels.create(level_number: 1)
          .tasks.create(content: "test#{i} content")
          i += 1
        end

        Task.all.each do |task|
          UserTask.create(task_id: task[:id],
                          user_id: User.first[:id])
        end

        get :index

        expect(assigns[:preview_topics].length).to eq(5)
      end
    end
  end
end
