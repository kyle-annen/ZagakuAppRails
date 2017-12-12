class TopicLevel < ApplicationRecord
  belongs_to :topic
  has_many :tasks
  has_many :goals
end
