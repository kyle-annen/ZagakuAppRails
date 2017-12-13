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

    @topic = LearningTrailsHelper.get_topic_json(topic_id, current_user.id.to_i)
  end

  def add
    if UserTopic.where(user_id: current_user.id, topic_id: topic_params[:topic_id]).empty?
      UserTopic.create(
        topic_version: topic_params[:topic_version],
        topic_id: topic_params[:topic_id],
        user_id: current_user.id
      )
      Topic.find(topic_params[:topic_id]).topic_levels.all.each do |level|
        Task.where(topic_level_id: level[:id]).each do |task|
          UserTask.create(user_id: current_user.id, task_id: task[:id])
        end
        Goal.where(topic_level_id: level[:id]).each do |goal|
          UserGoal.create(user_id: current_user.id, goal_id: goal[:id])
        end
      end
    end

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def complete_task
    user_task = UserTask.where(user_id: current_user.id, task_id: params[:task_id]).first
    user_task.complete = true
    user_task.save

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def reset_task
    user_task = UserTask.where(user_id: current_user.id, task_id: params[:task_id]).first
    user_task.complete = false
    user_task.save

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def complete_goal
    user_goal = UserGoal.where(user_id: current_user.id, goal_id: params[:goal_id]).first
    user_goal.complete = true
    user_goal.save

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  def reset_goal
    user_goal = UserGoal.where(user_id: current_user.id, goal_id: params[:goal_id]).first
    user_goal.complete = false
    user_goal.save

    redirect_to "/learning-trails/#{topic_params[:topic_id]}##{topic_params[:name]}"
  end

  private

  def topic_params
    params.permit(:topic_id, :task_id, :topic_version, :id, :name, :task_id)
  end
end
