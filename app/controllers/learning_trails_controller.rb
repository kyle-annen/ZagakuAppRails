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
    @lessons = topic.lessons.order(:id)
    @levels = topic.lessons
                   .where(lesson_type: 'task')
                   .distinct(:level)
                   .pluck(:level)
  end

  def add
    if Topic.find(topic_params[:topic_id])
            .user_lessons
            .where(user_id: current_user.id)
            .empty?
      Topic.find(topic_params[:topic_id]).lessons.all.each do |lesson|
        lesson.user_lessons.create(
          user_id: current_user.id,
          lesson_type: lesson.lesson_type,
          version: lesson.version
        )
      end
    end

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def complete_task
    lesson = UserLesson.where(user_id: current_user.id, lesson_id: params[:lesson_id].to_i).first
    lesson.complete = true
    lesson.save

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def reset_task
    UserLesson.where(
      user_id: current_user.id,
      lesson_id: params[:lesson_id].to_i
    ).first .update(complte: false)

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  private

  def topic_params
    params.permit(:topic_id, :lesson_id, :topic_version, :id, :name)
  end
end
