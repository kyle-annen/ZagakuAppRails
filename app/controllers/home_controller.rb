class HomeController < ApplicationController
  include HomeHelper
  include LearningTrailsHelper

  def index
    team_photo_resources = team_photos
    @preview_topics = set_preview_topics
    @upcoming = HomeHelper.setup_preview_events(future_events.limit(4),
                                                team_photo_resources)
    @this_week = HomeHelper.setup_preview_events(events_this_week,
                                                 team_photo_resources)
  end

  private

  def set_preview_topics
    preview_topics = []
    Topic.all.each do |topic|
      completion = task_completion_percentage(topic.id, current_user.id)
      preview_topics << {
        id: topic.id,
        name: topic.name.split('.')[0].titlecase,
        version: topic.version,
        percent_complete: completion
      }
    end
    preview_topics.sort_by{ |topic| topic[:percent_complete]}.reverse.first(5)
  end

  def events_this_week
    Event.where(start_time: Time.current.beginning_of_week..Time.current.end_of_week).order(start_time: :asc)
  end

  def future_events
    Event.where("start_time >= ?", Time.current).order(start_time: :asc)
  end

  def team_photos
    MetaInspector
      .new('https://8thlight.com/team/')
      .images
      .to_a
  end
end
