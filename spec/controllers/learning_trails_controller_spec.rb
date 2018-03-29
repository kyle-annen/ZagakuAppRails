# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LearningTrailsController, type: :controller do
  before(:each) do
    Category.delete_all
    Topic.delete_all
    Lesson.delete_all
    Category.create(category: 'testing')
    Category.first.topics.create(name: 'test.md', version: 0)
    Topic.first.lessons.create(level: 1, lesson_type: 'task', content: 'test task', version: 0)
    Topic.first.lessons.create(level: 1, lesson_type: 'goal', content: 'test goal', version: 0)
    Topic.first.lessons.create(level: 1, lesson_type: 'reference', content: 'test reference', version: 0)

    User.create(
      email: 'test@test.com',
      password: Devise.friendly_token[0, 20],
      first_name: 'test', last_name: 'test'
    )
  end

  after(:each) do
    Category.delete_all
    Topic.delete_all
    Lesson.delete_all
  end

  describe '#index' do
    it 'renders the index page' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'returns an active record relation of all Categories' do
      get :index

      expect(Category.all).to eq(assigns(:categories))
    end
  end

  describe '#add' do
    it 'adds the relations to the join tables' do
      sign_in(User.first)

      topic_id = Topic.first[:id]
      task_lesson_ids = Topic.first
                             .lessons
                             .where(lesson_type: 'task')
                             .pluck(:id)
      goal_lesson_ids = Topic.first
                             .lessons
                             .where(lesson_type: 'goal')
                             .pluck(:id)
      reference_lesson_ids = Topic.first
                                  .lessons
                                  .where(lesson_type: 'reference')
                                  .pluck(:id)

      get :add, params: { topic_id: topic_id }

      actual_task_lesson_ids = Topic.first
                                    .user_lessons
                                    .where(user_id: User.first.id, lesson_type: 'task')
                                    .pluck(:lesson_id)
      actual_goal_lesson_ids = Topic.first
                                    .user_lessons
                                    .where(user_id: User.first.id, lesson_type: 'goal')
                                    .pluck(:lesson_id)
      actual_reference_lesson_ids = Topic.first
                                         .user_lessons
                                         .where(user_id: User.first.id, lesson_type: 'reference')
                                         .pluck(:lesson_id)

      task_lesson_ids.each do |n|
        expect(actual_task_lesson_ids).to include n
      end

      goal_lesson_ids.each do |n|
        expect(actual_goal_lesson_ids).to include n
      end

      reference_lesson_ids.each do |n|
        expect(actual_reference_lesson_ids).to include n
      end
    end
  end

  describe '#show' do
    it 'routes to topic page if given id' do
      sign_in(User.first)
      topic_id = Topic.first[:id]
      get :add, params: { topic_id: topic_id }

      get :show, params: { id: topic_id }

      expect(response).to render_template :show
      expect(response.status).to eq(200)
    end

    it 'routes to topic page if given id' do
      sign_in(User.first)
      topic_id = Topic.first[:id]
      get :add, params: { topic_id: topic_id }

      get :show, params: { name: 'test' }

      expect(response).to render_template :show
      expect(response.status).to eq(200)
    end
  end

  describe '#complete_task' do
    it 'it completes the lesson in the UserLesson table' do
      sign_in(User.first)
      topic_id = Topic.first[:id]
      get :add, params: { topic_id: topic_id }

      user_lesson = Topic.first.user_lessons.where(user_id: User.first.id, lesson_type: 'task').first
      expect(user_lesson[:complete]).to be_falsey

      get :complete_task, params: { user_lesson_id: user_lesson.id }
      user_lesson = Topic.first.user_lessons.where(user_id: User.first.id, lesson_type: 'task').first
      expect(user_lesson[:complete]).to be_truthy
    end
  end

  describe '#reset_task' do
    it 'it resets the lesson in the UserLesson table' do
      sign_in(User.first)
      topic_id = Topic.first[:id]
      get :add, params: { topic_id: topic_id }
      user_lesson = Topic.first.user_lessons.where(user_id: User.first.id, lesson_type: 'task').first

      get :complete_task, params: { user_lesson_id: user_lesson.id }

      user_lesson = Topic.first.user_lessons.where(user_id: User.first.id, lesson_type: 'task').first
      expect(user_lesson[:complete]).to be_truthy

      get :reset_task, params: { user_lesson_id: user_lesson.id }
      user_lesson = Topic.first.user_lessons.where(user_id: User.first.id, lesson_type: 'task').first
      expect(user_lesson[:complete]).to be_falsey
    end
  end

  describe '#resolve_topic_id' do
    it 'gets the topic id from id if it exists' do
      sut = LearningTrailsController.new
      topic_id = Topic.first.id
      name = nil

      result = sut.resolve_topic_id(topic_id, name)

      expect(result).to eq(topic_id)
    end

    it 'finds topic by name' do
      sut = LearningTrailsController.new
      topic_id = nil
      name = Topic.first.name.split('.')[0]

      result = sut.resolve_topic_id(topic_id, name)

      expect(result).to eq(Topic.first.id)
    end
  end

  describe 'current_version?' do
    it 'returns true if user version is most recent version' do
      sign_in(User.first)
      get :add, params: { topic_id: Topic.first[:id] }
      sut = LearningTrailsController.new
      user = User.first
      topic = Topic.first

      is_current_version = sut.current_version?(topic, user)

      expect(is_current_version).to be_truthy
    end

    it 'returns false if the user version is no the most recent version' do
      sign_in(User.first)
      get :add, params: { topic_id: Topic.first[:id] }
      sut = LearningTrailsController.new
      user = User.first
      Topic.first.update(version: 1)
      topic = Topic.first

      is_current_version = sut.current_version?(topic, user)

      expect(is_current_version).to be_falsey
    end

    it 'returns false if there is no user lesson version' do
      sign_in(User.first)
      get :add, params: { topic_id: Topic.first[:id] }
      sut = LearningTrailsController.new
      user = User.first
      UserLesson.delete_all
      topic = Topic.first

      is_current_version = sut.current_version?(topic, user)

      expect(is_current_version).to be_falsey
    end
  end
end
