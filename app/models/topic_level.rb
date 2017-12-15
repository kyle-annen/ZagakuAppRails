class TopicLevel < ApplicationRecord
  belongs_to :topic
  has_many :tasks
  has_many :goals
  has_many :references
end
