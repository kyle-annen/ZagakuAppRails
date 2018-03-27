module LearningTrailsHelper
  def task_completion_percentage(topic, user)
    total = total_tasks(topic, user)
    completed = completed_tasks(topic, user)
    if total.zero?
      '0%'
    else
      (completed / total.to_f * 100).round.to_s + '%'
    end
  end

  def total_tasks(topic, user)
    version = topic_version(topic, user)
    topic.lessons
         .where(
           lesson_type: 'task',
           version: version
         ).size
  end

  def completed_tasks(topic, user)
    version = topic_version(topic, user)
    topic.user_lessons
         .where(
           user_id: user.id,
           lesson_type: 'task',
           complete: true,
           version: version
         ).size
  end

  def topic_version(topic, user)
    topic.user_lessons
         .where(user_id: user.id)
         .distinct(:version)
         .pluck(:version)
         .max
  end

  def user_lessons_hash(user_id, topic_id, version)

    query = <<-SQL
      SELECT * FROM lessons
      LEFT JOIN user_lessons
      ON user_lessons.lesson_id = lessons.id
      WHERE lessons.topic_id = '#{topic_id}'
      AND user_lessons.user_id = '#{user_id}'
      AND user_lessons.version = '#{version}'
      ORDER BY lessons.level ASC, lessons.lesson_type DESC
    SQL

    ActiveRecord::Base.connection.exec_query(query)
  end

  def find_topic_id(id, name)
    topic_id = id
    topic_id = Topic.where(name: name).first.id if id.nil?
    topic_id
  end


  def current_version?(topic, user)
    topic.version == topic_version(topic, user)
  end
end
