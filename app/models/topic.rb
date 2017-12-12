class Topic < ApplicationRecord
  belongs_to :category
  has_many :topic_levels
  has_many :users, through: :user_topics
end
