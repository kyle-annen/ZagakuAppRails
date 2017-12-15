require 'open-uri'

# This module is specific to the format of the markdown in learning
# trails github repo. It is not intended to have any extended use.

module TopicContentService

  @regex = {
      references: Regexp.new(/#+\sOngoing\sReference/),
      level: Regexp.new(/#+\sLevel\s\d+/)
  }


  def save_topic_content(topic)
    version_exists = topic.topic_levels.exists?(version: topic.version)
    return if version_exists
    raw_content = get_raw_content(topic.download_url)
    content_and_references = raw_content.split(@regex[:references])
    summary_and_levels = content_and_references[0].split(@regex[:level])
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
      topic_level = topic.topic_levels.create(
        level_number: index + 1,
        version: topic.version
      )
      goals, tasks = get_tasks_and_goals(level)
      remove_empty_values(goals, tasks)
      save_tasks(tasks, topic_level, topic.version)
      save_goals(goals, topic_level, topic.version)
    end
  end

  def get_tasks_and_goals(level)
    level_tasks_and_goals = level.split('### You should be able to')
    tasks = []
    goals = []

    if level_tasks_and_goals.size > 0
      tasks = level_tasks_and_goals[0].strip.split(%r{\*\s})
    end

    if level_tasks_and_goals.size > 1
      goals = level_tasks_and_goals[1].strip.split(%r{\*\s})
    end
    return goals, tasks
  end

  def remove_empty_values(goals, tasks)
    tasks.shift
    goals.shift
  end

  def save_goals(goals, topic_level, version)
    goals.each do |goal|
      clean_goal = goal.strip
      goal = topic_level.goals.new(content: clean_goal)
      goal.version = version
      goal.save
    end
  end

  def save_tasks(tasks, topic_level, version)
    tasks.each do |task|
      clean_task = task.strip
      task = topic_level.tasks.new(content: clean_task)
      task.version = version
      task.save
    end
  end

  def get_raw_content(topic_raw_url)
    uri = URI.parse(topic_raw_url)
    uri.read
  end
end