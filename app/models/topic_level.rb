class TopicLevel < ApplicationRecord
  belongs_to :topic
  has_many :topic_level_tasks
  has_many :topic_level_goals
end
