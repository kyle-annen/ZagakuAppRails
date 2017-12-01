class Topic < ApplicationRecord
  belongs_to :category
  has_many :topic_levels
end
