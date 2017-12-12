module LearningTrailsHelper
  def get_topic_json(topic_id, user_id)
    topic = Topic.find(topic_id).as_json
    topic['levels'] = TopicLevel.where(topic_id: topic['id']).as_json
    topic['levels'].map do |level|
      level['tasks'] = Task.where(topic_level_id: level['id']).as_json
      level['goals'] = Goal.where(topic_level_id: level['id']).as_json
      get_task_status(level, user_id)
      get_goal_status(level, user_id)
    end
    topic
  end

  private

  def get_goal_status(level, user_id)
    level['goals'].map do |goal|
      goal['complete'] = UserGoal.where(
        user_id: user_id,
        goal_id: goal['id']
      ).first[:complete]
    end
  end

  def get_task_status(level, user_id)
    level['tasks'].map do |task|
      task['complete'] = UserTask.where(
        user_id: user_id,
        task_id: task['id']
      ).first[:complete]
    end
  end
end
