require 'open-uri'

module TopicContentService

  def save_topic_conent(topic_raw_url)
    raw_content = get_raw_content(topic_raw_url)
  end

  def get_raw_content(topic_raw_url)
    uri = URI.parse(topic_raw_url)
    uri.read
  end
end