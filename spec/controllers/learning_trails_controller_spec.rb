require 'rails_helper'

RSpec.describe LearningTrailsController, type: :controller do
  before(:each) do
    Category.create(category: 'testing')
    Category.first.topics.create(name: 'test.md')
    Topic.first.topic_levels.create(level_number: 1)
    TopicLevel.first.tasks.create(content: 'test task', version: 0)
    TopicLevel.first.goals.create(content: 'test goal', version: 0)
    Topic.first.references.create(content: 'test reference', version: 0)

    User.create(
      email: 'test@test.com',
      password: Devise.friendly_token[0, 20],
      first_name: 'test', last_name: 'test'
    )
  end

  after(:each) do
    Category.delete_all
    Topic.delete_all
    TopicLevel.delete_all
    Task.delete_all
    Goal.delete_all
    Reference.delete_all
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

      get :add, params: { topic_id: 1 }

      expect(UserTopic.first[:topic_id]).to eq(1)
      expect(UserTopic.first[:user_id]).to eq(1)
      expect(UserGoal.first[:goal_id]).to eq(1)
      expect(UserGoal.first[:user_id]).to eq(1)
      expect(UserTask.first[:task_id]).to eq(1)
      expect(UserTask.first[:user_id]).to eq(1)
      expect(UserReference.first[:user_id]).to eq(1)
      expect(UserReference.first[:reference_id]).to eq(1)
    end
  end

  describe '#show' do
    it 'routes to topic page if given id' do
      sign_in(User.first)
      get :add, params: { topic_id: 1 }

      get :show, params: { id: 1 }

      expect(response).to render_template :show
      expect(response.status).to eq(200)
    end

    it 'routes to topic page if given id' do
      sign_in(User.first)
      get :add, params: { topic_id: 1 }

      get :show, params: { name: 'test' }

      expect(response).to render_template :show
      expect(response.status).to eq(200)
    end
  end

  describe '#complete_task' do
    it 'it competes the task in the UserTask table' do
      sign_in(User.first)
      get :add, params: { topic_id: 1 }

      expect(UserTask.find(1)[:complete]).to be_falsey

      get :complete_task, params: { task_id: 1 }

      expect(UserTask.find(1)[:complete]).to be_truthy
    end
  end

  describe '#reset_task' do
    it 'it competes the task in the UserTask table' do
      sign_in(User.first)
      get :add, params: { topic_id: 1 }

      get :complete_task, params: { task_id: 1 }

      expect(UserTask.find(1)[:complete]).to be_truthy

      get :reset_task, params: { task_id: 1 }

      expect(UserTask.find(1)[:complete]).to be_falsey
    end
  end

  describe '#complete_goal' do
    it 'it competes the goal in the UserGoal table' do
      sign_in(User.first)
      get :add, params: { topic_id: 1 }

      expect(UserGoal.find(1)[:complete]).to be_falsey

      get :complete_goal, params: { goal_id: 1 }

      expect(UserGoal.find(1)[:complete]).to be_truthy
    end
  end

  describe '#reset_goal' do
    it 'it competes the goal in the UserGoal table' do
      sign_in(User.first)
      get :add, params: { topic_id: 1 }

      get :complete_goal, params: { goal_id: 1 }

      expect(UserGoal.find(1)[:complete]).to be_truthy

      get :reset_goal, params: { goal_id: 1 }

      expect(UserGoal.find(1)[:complete]).to be_falsey
    end
  end
end
