include LearningTrailsHelper

class LearningTrailsController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    topic_id = resolve_topic_id(topic_params[:id], topic_params[:name])
    @topic = Topic.find(topic_id)
  end

  # TODO: KEA move to API Controller

  def add
    topic = Topic.find(topic_params[:topic_id])
    version = topic_params[:version]
    param_hash = { user_id: current_user.id, version: version }
    lessons_version_empty = topic.user_lessons.where(param_hash).empty?
    create_user_lessons(topic) if lessons_version_empty
    redirect_show_with_scroll
  end

  def complete_task
    task_complete(true)
    redirect_show_with_scroll
  end

  def reset_task
    task_complete(false)
    redirect_show_with_scroll
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
          .as_json
          .group_by(level_group)
          .sort
          .map(group_level_by_task)
  end

  def resolve_topic_id(id, name)
    id.nil? ? Topic.where(name: "#{name}.md").first.id : id
  end

  def current_version?(topic, user)
    topic.version == topic_version(topic, user)
  end

  def build_redirect_url(topic_id, name)
    "/learning-trails/#{topic_id}##{name}"
  end

  def create_user_lessons(topic)
    topic.lessons.find_each do |lesson|
      lesson.user_lessons.create(user_id: current_user.id,
                                 lesson_type: lesson.lesson_type,
                                 version: lesson.version)
    end
  end

  private

  def topic_params
    params.permit(:topic_id, :lesson_id, :topic_version,
                  :id, :user_lesson_id, :name)
  end

  def redirect_show_with_scroll
    redirect_to build_redirect_url(topic_params[:topic_id], topic_params[:name])
  end

  def task_complete(boolean)
    UserLesson.find(topic_params[:user_lesson_id]).update(complete: boolean)
  end
end
