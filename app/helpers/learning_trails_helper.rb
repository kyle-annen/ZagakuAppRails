# frozen_string_literal: true

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
    param_hash = { lessons: { topic_id: topic_id },
                   user_lessons: { user_id: user_id, version: version } }

    level_group = ->(relation) { relation['level'] }

    lesson_type_group = ->(relation) { relation['lesson_type'] }

    group_level_by_task = ->(_, set) { set.group_by(lesson_type_group) }

    Lesson.select('lessons.*, user_lessons.*')
          .joins(:user_lessons)
          .where(param_hash).as_json
          .group_by(level_group).sort
          .map(group_level_by_task)
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
