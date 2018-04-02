# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TopicController, type: :controller do
  describe 'show' do
    render_views

    before(:each) do
      Topic.delete_all
      Lesson.delete_all
      UserLesson.delete_all
      User.delete_all
      Category.create(category: 'testing')
      Category.first.topics.create(name: 'test.md', version: 0)
      Topic.first.lessons.create(level: 1, lesson_type: 'task', content: 'test task 1', version: 0)
      Topic.first.lessons.create(level: 1, lesson_type: 'task', content: 'test task 2', version: 0)
      Topic.first.lessons.create(level: 1, lesson_type: 'goal', content: 'test goal 1', version: 0)
      Topic.first.lessons.create(level: 1, lesson_type: 'goal', content: 'test goal 2', version: 0)
      Topic.first.lessons.create(level: 1, lesson_type: 'reference', content: 'test reference1-1', version: 0)
      Topic.first.lessons.create(level: 2, lesson_type: 'task', content: 'test task 1', version: 0)
      Topic.first.lessons.create(level: 2, lesson_type: 'task', content: 'test task 2', version: 0)
      Topic.first.lessons.create(level: 2, lesson_type: 'goal', content: 'test goal 1', version: 0)
      Topic.first.lessons.create(level: 2, lesson_type: 'goal', content: 'test goal 2', version: 0)
      Topic.first.lessons.create(level: 2, lesson_type: 'reference', content: 'test reference2-1', version: 0)

      User.create(email: 'test@test.com',
                  password: Devise.friendly_token[0, 20],
                  first_name: 'test',
                  last_name: 'test')
      sign_in(User.first)

      @controller = LearningTrailsController.new
      get :add, params: { topic_id: Topic.first }

      @controller = Api::V1::TopicController.new
    end

    after(:each) do
      Topic.delete_all
      Lesson.delete_all
      UserLesson.delete_all
      User.delete_all
    end

    it 'renders page if user is authorized' do
      hash = @controller.user_lessons_hash(User.first.id, Topic.first.id, 0)

      expect(hash.size).to eq(3)
      expect(hash.keys).to include(:'1')
      expect(hash.keys).to include(:'2')
      expect(hash.keys).to include(:references)

      expect(hash[:'1'].size).to eq(2)
      expect(hash[:'1'][:tasks].size).to eq(2)
      expect(hash[:'1'][:goals].size).to eq(2)

      expect(hash[:'2'].size).to eq(2)
      expect(hash[:'2'][:tasks].size).to eq(2)
      expect(hash[:'2'][:goals].size).to eq(2)
      expect(hash[:references].size).to eq(2)
    end
  end
end
