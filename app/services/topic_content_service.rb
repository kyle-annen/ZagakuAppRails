require 'open-uri'

module TopicContentService

  def save_topic_content(topic)
    raw_content = get_raw_content(topic.download_url)
    summary_and_levels = raw_content.split(%r{##\sLevel\s\d+\n\n})
    save_topic_summary(summary_and_levels, topic)
    parse_and_save_levels(summary_and_levels, topic)
  end

  def save_topic_summary(summary_and_levels, topic)
    summary_and_topic = summary_and_levels[0]
    topic.summary = summary_and_topic.split(%r{\n\n})[1]
    topic.save
  end

  def parse_and_save_levels(summary_and_levels, topic)
    summary_and_levels.shift
    summary_and_levels.each_with_index do |level, index|
      topic_level = topic.topic_levels.create(level_number: index + 1)
      goals, tasks = get_tasks_and_goals(level)
      remove_empty_values(goals, tasks)
      save_tasks(tasks, topic_level)
      save_goals(goals, topic_level)
    end
  end

  def get_tasks_and_goals(level)
    level_tasks_and_goals = level.split('### You should be able to')

    tasks = level_tasks_and_goals[0].strip.split(%r{\*\s})
    goals = level_tasks_and_goals[1].strip.split(%r{\*\s})
    return goals, tasks
  end

  def remove_empty_values(goals, tasks)
    tasks.shift
    goals.shift
  end

  def save_goals(goals, topic_level)
    goals.each do |goal|
      clean_goal = goal.strip
      topic_level.topic_level_goals.create(content: clean_goal)
    end
  end

  def save_tasks(tasks, topic_level)
    tasks.each do |task|
      clean_task = task.strip
      topic_level.topic_level_tasks.create(content: clean_task)
    end
  end

  def get_raw_content(topic_raw_url)
    uri = URI.parse(topic_raw_url)
    uri.read
  end
end