module LearningTrailsHelper
  def get_topic_json(topic_id, user_id)
    topic = Topic.find(topic_id).as_json
    topic['levels'] = TopicLevel.where(topic_id: topic['id']).as_json
    topic['levels'].map do |level|
      level['tasks'] = Task.where(topic_level_id: level['id']).as_json
      level['goals'] = Goal.where(topic_level_id: level['id']).as_json
      level['tasks'].map do |task|
        task['complete'] = UserTask.where( user_id: user_id, task_id: task['id'] ).first[:complete]
        task['link'] = URI.extract(task['content']).first
      end
      level['goals'].map do |goal|
        goal['complete'] = UserGoal.where( user_id: user_id, goal_id: goal['id'] ).first[:complete]
        goal['link'] = URI.extract(goal['content']).first
      end
    end
    topic

  end
end
