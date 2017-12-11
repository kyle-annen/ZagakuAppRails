module LearningTrailsHelper

  def get_topic_relation(topic_id)
    Topic.find(topic_id).as_json
  end
end