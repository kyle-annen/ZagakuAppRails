class TopicLevelGoal < ApplicationRecord
  belongs_to :topic_level
  belongs_to :topic
end
