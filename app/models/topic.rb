class Topic < ApplicationRecord
  belongs_to :category
  has_many :lessons
  has_many :user_lessons, through: :lessons
end
