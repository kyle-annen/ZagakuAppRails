module LearningTrailsHelper

  def get_topic_json(topic_id)
    topic = Topic.find(topic_id).as_json
    topic['levels'] = TopicLevel.where(topic_id: topic['id']).as_json
    topic['levels'].map { |level|
      level['tasks'] = TopicLevelTask.where(topic_level_id: level['id']).as_json
      level['goals'] = TopicLevelGoal.where(topic_level_id: level['id']).as_json
    }
    topic
  end
end