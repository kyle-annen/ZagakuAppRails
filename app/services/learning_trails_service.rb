
module LearningTrailsService
  def save_topics(topics)
    topics.each do |topic|
      topic_updated_fields = rename_type_field(topic)
      category_name = get_category_from_topic(topic_updated_fields)
      category_exists = Category.exists?(category: category_name)
      category = get_or_create_category(category_exists, category_name)

      if Topic.exists?(path: topic[:path])
        Topic.where(path: topic[:path])
          .update(topic_updated_fields)
      else
        category.topics.create(topic_updated_fields)
      end
    end
  end

  def get_category_from_topic(topic)
    topic[:path].split('/').first
  end

  def get_or_create_category(category_exists, category_name)
    if category_exists
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
