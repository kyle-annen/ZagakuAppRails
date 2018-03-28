# frozen_string_literal: true

include LearningTrailsHelper

class LearningTrailsController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    topic_id = resolve_topic_id(topic_params[:id], topic_params[:name])

    @topic = Topic.find(topic_id)
  end

  def show_api
    topic_id = resolve_topic_id(topic_params[:id], topic_params[:name])
    @topic = Topic.find(topic_id)
    @version = topic_version(@topic, current_user)
    @user_lessons = user_lessons_hash(current_user.id, topic_id, @version)
    render json: { topic: @topic, user_lessons: @user_lessons }
  end

  def add
    topic = Topic.find(topic_params[:topic_id])
    version = topic_params[:version]
    lessons_version_empty = topic.user_lessons
                                 .where(user_id: current_user.id, version: version)
                                 .empty?
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
