require 'rails_helper'
include LearningTrailsHelper


RSpec.describe LearningTrailsHelper, type: :helper do
  before(:each) do
    Category.delete_all
    Topic.delete_all
    User.delete_all
    Lesson.delete_all
    UserLesson.delete_all

    User.create(
      email: 'test@test.com',
      password: Devise.friendly_token[0, 20],
      first_name: 'test',
      last_name: 'test'
    )

    category = Category.create(category: 'clean-code')
    topic = category.topics.create(
      name: 'legacy-code.md',
      summary: 'summary',
      path: 'clean-code/legacy-code.md',
      sha: 'df0a42d82a29077385b1adbe44a05b7552d4ae8f',
      size: 901,
      url: '',
      html_url: '',
      git_url: '',
      download_url: '',
      github_type: 'file',
      version: 0
    )

    [1, 2].each do |n|
      topic.lessons.create(
        [
          { lesson_type: 'reference', level: n, version: 0 },
          { lesson_type: 'task', level: n, content: 'number http://google.com) 1', version: 0 },
          { lesson_type: 'goal', level: n, content: 'get thru it (/legacy-code.md) ', version: 0 }
        ]
      )
    end

    Topic.first.lessons.each do |lesson|
      lesson.user_lessons
            .create(
              user_id: User.first.id,
              version: 0,
              lesson_type: lesson.lesson_type
            )
    end
  end

  after(:each) do
    Category.delete_all
    Topic.delete_all
    User.delete_all
    Lesson.delete_all
    UserLesson.delete_all
  end

  describe 'topic_version' do
    it 'returns the topic version for the topic/user' do
      topic = Topic.first
      user = User.first
      topic_version = topic_version(topic, user)
      expect(topic_version).to eq(0)
    end
  end

  describe 'total_tasks' do
    it 'returns the total tasks for a topic' do
      topic = Topic.first
      user = User.first
      total_tasks = total_tasks(topic, user)
      expect(total_tasks).to eq(2)
    end
  end

  describe 'completed_tasks' do
    it 'returns 0 for a topic that has no completed tasks' do
      topic = Topic.first
      user = User.first
      completed_tasks = completed_tasks(topic, user)
      expect(completed_tasks).to eq(0)
    end

    it 'returns 1 if one lesson is complete' do
      user_lesson = UserLesson.where(lesson_type: 'task').first
      user_lesson[:complete] = true
      user_lesson.save

      topic = Topic.first
      user = User.first
      completed_tasks = completed_tasks(topic, user)
      expect(completed_tasks).to eq(1)
    end
  end

  describe 'task_completion_percentage' do
    it 'returns 0% if no tasks are complete' do
      user = User.first
      topic = Topic.first

      percentage = task_completion_percentage(topic, user)
      expect(percentage).to eq('0%')
    end

    it 'returns 50% if half are complete' do
      user_lesson = UserLesson.where(lesson_type: 'task').first
      user_lesson[:complete] = true
      user_lesson.save

      user = User.first
      topic = Topic.first

      percentage = task_completion_percentage(topic, user)
      expect(percentage).to eq('50%')
    end
  end
end
