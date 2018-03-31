# frozen_string_literal: true

class Api::V1::TopicController < ApplicationController
  def index; end

  def show
    topic_id = resolve_topic_id(topic_params[:topic_id], topic_params[:name])
    @topic = Topic.find(topic_id)
    @version = topic_version(@topic, current_user)
    @user_lessons = user_lessons_hash(current_user.id, topic_id, @version)
    render json: { topic: @topic, user_lessons: @user_lessons }
  end

  private

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

  def user_lessons_hash(user_id, topic_id, version)
    param_hash = {
      lessons: { topic_id: topic_id },
      user_lessons: { user_id: user_id, version: version }
    }
    level_group = ->(relation) { relation['level'] }
    lesson_type_group = ->(relation) { relation['lesson_type'] }
    group_level_by_task = ->(_, set) { set.group_by(lesson_type_group) }
    Lesson.select('lessons.*, user_lessons.*')
          .joins(:user_lessons)
          .where(param_hash)
          .group_by { level_group }
          .sort


  end
end
