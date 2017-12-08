class Topic < ApplicationRecord
  belongs_to :category
  has_many :topic_levels
  has_many :topic_level_tasks, through: :topic_levels
  has_many :topic_level_goals, through: :topic_levels
end
