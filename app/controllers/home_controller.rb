class HomeController < ApplicationController
  include HomeHelper
  include LearningTrailsHelper

  def index
    @preview_topics = Topic.includes(:user_lessons)
                           .order('user_lessons.updated_at ASC')
                           .distinct('user_lessons.id')
                           .limit(5)
    @preview_events = set_preview_events
  end

  private

  def set_preview_events
    HomeHelper.setup_preview_events(upcoming_events, team_photos)
  end

  def upcoming_events
    time_range = Time.now..(Time.now + 1.month)
    Event.where(start_time: time_range)
         .order(start_time: :asc)
         .limit(3)
  end

  def team_photos
    MetaInspector
      .new('https://8thlight.com/team/')
      .images
      .to_a
  end
end
