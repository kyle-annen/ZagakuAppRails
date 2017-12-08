class TopicLevelTask < ApplicationRecord
  belongs_to :topic_level
  belongs_to :topic
end
