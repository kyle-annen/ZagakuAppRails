class StaticPagesController < ApplicationController
  include StaticPagesHelper
  include LearningTrailsHelper
  before_action :setup_week

  def index
    @topics = []
    Topic.all.each do |topic|
      @topics << {id: topic.id, name: topic.name.split(".")[0].titlecase, percent_complete: LearningTrailsHelper.task_completion_percentage(topic.id, current_user.id)}
    end
  end

  private

  def setup_week
    @this_week = StaticPagesHelper.get_week_details(upcoming_events,team_photos)
  end

  def upcoming_events
    Event.where(start_time: Time.now.beginning_of_week..Time.now.end_of_week)
  end

  def team_photos
    MetaInspector.new('https://8thlight.com/team/').images.to_a
  end

end


