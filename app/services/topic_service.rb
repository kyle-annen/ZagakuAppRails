
# This module is specific to the format of the markdown in learning
# trails github repo. It is not intended to have any extended use.

module TopicService
  def save_topics(topics)
    topics.each do |topic|
      next unless topic[:path].include?('/')
      topic_updated_fields = rename_type_field(topic)
      topic_links_removed = remove_topic_links(topic_updated_fields)
      category = get_or_create_category(topic_links_removed)
      update_or_create_topic(category, topic_links_removed)
    end
  end

  private

  def rename_type_field(topic)
    topic.map do |key, value|
      key == :type ? [:github_type, value] : [key, value]
    end.to_h
  end

  def remove_topic_links(topic_updated_fields)
    topic_updated_fields.to_h.delete(:_links)
    topic_updated_fields
  end

  def get_or_create_category(topic_links_removed)
    category_name = get_category_from_topic(topic_links_removed)
    unless Category.exists?(category: category_name)
      Category.create(category: category_name)
    end
    Category.where(category: category_name).first
  end

  def update_or_create_topic(category, topic_links_removed)
    if Topic.exists?(path: topic_links_removed[:path])
      topic = Topic.where(path: topic_links_removed[:path]).max_by(&:version)
      if topic.sha != topic_links_removed[:sha]
        increment_version(topic, topic_links_removed)
      end
    else
      save_initial_version(category, topic_links_removed)
    end
  end

  def save_initial_version(category, topic_links_removed)
    topic = category.topics.new(topic_links_removed)
    topic[:version] = 0
    topic.save
  end

  def increment_version(topic, topic_links_removed)
    topic_links_removed[:version] = topic.version + 1
    topic.update(topic_links_removed)
  end

  def get_category_from_topic(topic)
    topic[:path].split('/').first
  end
end
