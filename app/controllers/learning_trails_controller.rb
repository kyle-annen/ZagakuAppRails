include LearningTrailsHelper

class LearningTrailsController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    topic_id = LearningTrailsHelper
               .find_topic_id(topic_params[:id], topic_params[:name])

    @topic = Topic.find(topic_id)
  end

  def show_api
    topic_id = LearningTrailsHelper
                   .find_topic_id(topic_params[:id], topic_params[:name])

    @topic = Topic.find(topic_id)

    @version = LearningTrailsHelper.topic_version(@topic, current_user)

    @user_lessons = LearningTrailsHelper
                        .user_lessons_hash(current_user.id, topic_id, @version)
    render json: { topic: @topic, user_lessons: @user_lessons }
  end

  def add
    topic = Topic.find(topic_params[:topic_id])
    version = topic_params[:version]

    if topic.user_lessons.where(user_id: current_user.id, version: version).empty?
      topic.lessons.all.each do |lesson|
        lesson.user_lessons.create(user_id: current_user.id,
                                   lesson_type: lesson.lesson_type,
                                   version: lesson.version)
      end
    end

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def complete_task
    UserLesson.find(topic_params[:user_lesson_id])
              .update(complete: true)

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def reset_task
    UserLesson.find(topic_params[:user_lesson_id])
              .update(complete: false)

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  private

  def topic_params
    params.permit(:topic_id, :lesson_id, :topic_version, :id, :user_lesson_id, :name)
  end
end
