class StaticPagesController < ApplicationController
  include StaticPagesHelper
  include LearningTrailsHelper

  def index
    @preview_topics = set_preview_topics
    @preview_events = set_preview_events
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

  def set_preview_events
    StaticPagesHelper.setup_preview_events(upcoming_events, team_photos)
  end

  def upcoming_events
    Event.where(start_time: Time.now..(Time.now + 1.month)).limit(3).order(start_time: :asc)
  end

  def team_photos
    MetaInspector
      .new('https://8thlight.com/team/')
      .images
      .to_a
  end
end
