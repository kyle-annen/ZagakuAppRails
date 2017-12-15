class Topic < ApplicationRecord
  belongs_to :category
  has_many :topic_levels
  has_many :users, through: :user_topics
  has_many :tasks, through: :topic_levels
  has_many :goals, through: :topic_levels
  has_many :references
  has_many :user_tasks, through: :tasks, source: :topic_levels
end
