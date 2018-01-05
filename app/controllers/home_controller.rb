class HomeController < ApplicationController
  include HomeHelper
  include LearningTrailsHelper

  def index
    team_photo_resources = team_photos
    @upcoming = HomeHelper.setup_preview_events(future_events.limit(4),
                                                team_photo_resources)
    @this_week = HomeHelper.setup_preview_events(events_this_week,
                                                 team_photo_resources)
    @preview_topics = lessons_for_preview.to_a.first(5)
  end

  private

  def lessons_for_preview
    Topic.includes(:user_lessons)
         .order('user_lessons.updated_at ASC')
         .distinct('user_lessons.id')
  end

  def events_this_week
    time_period = Time.current.beginning_of_week..Time.current.end_of_week
    Event.where(start_time: time_period)
         .order(start_time: :asc)
  end

  def future_events
    Event.where("start_time >= ?", Time.current)
         .order(start_time: :asc)
  end

  def team_photos
    MetaInspector
      .new('https://8thlight.com/team/')
      .images
      .to_a
  end
end
