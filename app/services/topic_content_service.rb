require 'open-uri'

module TopicContentService

  def save_topic_content(topic)
    raw_content = get_raw_content(topic.download_url)
    summary_and_levels = raw_content.split(%r{##\sLevel\s\d+\n\n})
    summary_and_topic = summary_and_levels[0]
    topic.summary = summary_and_topic.split(%r{\n\n})[1]
    topic.save

    summary_and_levels.shift

    summary_and_levels.each_with_index do |level, index|
      topic_level = topic.topic_levels.create({level_number: index + 1})

      level_parts = level.split('### You should be able to')

      tasks = level_parts[0].strip.split(%r{\*\s})
      goals = level_parts[1].strip.split(%r{\*\s})

      tasks.shift
      goals.shift

      tasks.each do |task|
        clean_task = task.strip
        topic_level.topic_level_tasks.create({content: clean_task})
      end

      goals.each do |goal|
        clean_goal = goal.strip
        topic_level.topic_level_goals.create({content: clean_goal})
      end

    end
  end

  def get_raw_content(topic_raw_url)
    uri = URI.parse(topic_raw_url)
    uri.read
  end
end