class LearningTrailsController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @topic = Topic.find(params[:id])
  end
end
