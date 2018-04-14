# frozen_string_literal: true

class Api::V1::TopicController < ApplicationController
  def index; end

  def show
    topic_id = resolve_topic_id(topic_params[:topic_id], topic_params[:name])
    @topic = Topic.find(topic_id)
    version = topic_version(@topic, current_user)
    @user_lessons = user_lessons_hash(current_user.id, topic_id, version)
    render json: { topic: @topic, user_lessons: @user_lessons }
  end

  def user_lessons_hash(user_id, topic_id, version)
    param_hash = {
      lessons: { topic_id: topic_id },
      user_lessons: { user_id: user_id, version: version }
    }

    lessons = Lesson
      .select('lessons.*, user_lessons.*')
      .joins(:user_lessons)
      .where(param_hash).as_json

    order_lesson_hash(lessons)
  end

  private

  def order_lesson_hash(lessons)
    hash = {}

    levels = lessons.map { |lesson| lesson['level']}.uniq
    levels.each do |level_num|
      add_level_goals_and_lessons_to_hash(hash, lessons, level_num)
    end

    references = lessons.select {|lesson| lesson['lesson_type'] == 'reference'}
    hash[:references] = references
    hash
  end

  def add_level_goals_and_lessons_to_hash(hash, lessons, level_num)
    level_lessons = lessons.select {|lesson| lesson['level'] == level_num}
    tasks = level_lessons.select {|lesson| lesson['lesson_type'] == 'task'} .sort_by {|lesson| lesson['id']}
    goals = level_lessons.select {|lesson| lesson['lesson_type'] == 'task'} .sort_by {|lesson| lesson['id']}
    hash.merge!("#{level_num}": {'tasks': tasks, 'goals': goals})
  end

  def topic_params
    params.permit(:topic_id, :name)
  end

  def resolve_topic_id(id, name)
    id.nil? ? Topic.where(name: "#{name}.md").first.id : id
  end

  def topic_version(topic, user)
    topic.user_lessons
         .where(user_id: user.id)
         .distinct(:version)
         .pluck(:version)
         .max
  end
end
