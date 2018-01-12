include GithubService
include TopicService
include TopicContentService

class TopicJob < ApplicationJob
  def perform
    files = repository_files
    save_or_update_content(files)
  end

  private

  def repository_files
    GithubService.get_files(ENV['LEARNING_TRAILS_REPO'], '/')
  end

  def save_or_update_content(files)
    TopicService.save_topics(files)
    Topic.all.each do |topic|
      raw_content = GithubService.get_raw_content(topic)
      TopicContentService.save_topic_content(topic, raw_content)
    end
  end


end
