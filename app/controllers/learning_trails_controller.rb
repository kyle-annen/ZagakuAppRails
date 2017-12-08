class LearningTrailsController < ApplicationController
  def index
    @categories = Category.all
  end
end
