class StaticPagesController < ApplicationController
  include StaticPagesHelper
  include LearningTrailsHelper
  before_action :set_preview_topics, :set_preview_events

  def index; end

  private

  def set_preview_topics
    @preview_topics = []
    Topic.all.each do |topic|
      completion = task_completion_percentage(topic.id, current_user.id)
      @preview_topics << {
        id: topic.id,
        name: topic.name.split('.')[0].titlecase,
        percent_complete: completion
      }
    end
  end

  def set_preview_events
    @preview_events = StaticPagesHelper.setup_preview_events(upcoming_events, team_photos)
  end

  def upcoming_events
    Event.order(:start_time).limit(5)
  end

  def team_photos
    MetaInspector
      .new('https://8thlight.com/team/')
      .images
      .to_a
  end
end
