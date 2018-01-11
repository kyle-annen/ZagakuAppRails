include LearningTrailsHelper

class LearningTrailsController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    topic_id = topic_params[:id]

    if topic_params[:id].nil?
      name = "#{topic_params[:name]}.md"
      topic_id = Topic.where(name: name).first.id
    end

    topic = Topic.find(topic_id)
    @topic = topic
    version = LearningTrailsHelper.topic_version(topic, current_user)
    @user_lessons = topic.user_lessons.where(user_id: current_user.id, version: version)
    @lessons = topic.lessons.where(version: version).order(:id)
    @levels = topic.lessons
                   .where(lesson_type: 'task', version: version)
                   .distinct(:level)
                   .pluck(:level)
                   .sort
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
    lesson = UserLesson.where(user_id: current_user.id, id: topic_params[:lesson_id]).first
    lesson.complete = true
    lesson.save

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def reset_task
    UserLesson.where(
      user_id: current_user.id,
      id: topic_params[:lesson_id]
    ).first.update(complete: false)

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  private

  def topic_params
    params.permit(:topic_id, :lesson_id, :topic_version, :id, :name)
  end
end
