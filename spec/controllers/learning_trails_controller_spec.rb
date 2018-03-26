require 'rails_helper'

RSpec.describe LearningTrailsController, type: :controller do
  before(:each) do
    Category.create(category: 'testing')
    Category.first.topics.create(name: 'test.md')
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
end
