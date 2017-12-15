class StaticPagesController < ApplicationController
  include StaticPagesHelper
  def index
    @this_week = setup_week
  end

  private

  def setup_week
    StaticPagesHelper.get_week_details(upcoming_events,team_photos)
  end

  def upcoming_events
    Event.where(start_time: Time.now.beginning_of_week..Time.now.end_of_week)
  end

  def team_photos
    MetaInspector.new('https://8thlight.com/team/').images.to_a
  end

end


