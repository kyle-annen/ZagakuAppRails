module TopicService

  def save_topics(topics)
    topics.each do |topic|
      topic_updated_fields = rename_type_field(topic)
      category = get_or_create_category(topic_updated_fields)
      update_or_create_topic(category, topic_updated_fields)
    end
  end

  private

  def update_or_create_topic(category, topic_updated_fields)
    if Topic.exists?(path: topic_updated_fields[:path])
      Topic.where(path: topic_updated_fields[:path])
           .update(topic_updated_fields)
    else
      category.topics.create(topic_updated_fields)
    end
  end

  def get_category_from_topic(topic)
    topic[:path].split('/').first
  end

  def get_or_create_category(topic_updated_fields)
    category_name = get_category_from_topic(topic_updated_fields)
    if Category.exists?(category: category_name)
      Category.where(category: category_name)
    else
      Category.create(category: category_name)
    end
  end

  def rename_type_field(topic)
    topic.map do |key, value|
      key == :type ? [:github_type, value] : [key, value]
    end.to_h
  end
end
