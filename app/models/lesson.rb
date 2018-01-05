class Lesson < ApplicationRecord
  belongs_to :topic
  has_many :user_lessons
end

