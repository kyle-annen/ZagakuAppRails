class Category < ApplicationRecord
  has_many :topics, dependent: :destroy
end
