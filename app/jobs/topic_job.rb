include GithubService
include TopicService
include TopicContentService

class TopicJob < ApplicationJob
  def perform
    topics = GithubService.get_files("kyle-annen/test-repo", "/")
    TopicService.save_topics(topics)
    Topic.all.each do |topic|
      TopicContentService.save_topic_content(topic)
    end
  end
end
