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

  def topic_version(topic, user)
    topic.user_lessons
         .where(user_id: user.id)
         .distinct(:version)
         .pluck(:version)
         .max
  end

  def completed_tasks(topic, user)
    version = topic_version(topic, user)
    param_hash = {
      user_id: user.id,
      lesson_type: 'task',
      complete: true,
      version: version
    }
    topic.user_lessons.where(param_hash).size
  end

  def user_lessons_hash(user_id, topic_id, version)
    param_hash = {
      lessons: { topic_id: topic_id },
      user_lessons: { user_id: user_id, version: version }
    }

    level_group = ->(relation) { relation['level'] }

    lesson_type_group = ->(relation) { relation['lesson_type'] }

    group_level_by_task = ->(_, set) { set.group_by(lesson_type_group) }

    Lesson.select('lessons.*, user_lessons.*')
          .joins(:user_lessons)
          .where(param_hash).as_json
          .group_by(level_group).sort
          .map(group_level_by_task)
  end

  def resolve_topic_id(id, name)
    id.nil? ? Topic.where(name: "#{name}.md").first.id : id
  end

  def current_version?(topic, user)
    topic.version == topic_version(topic, user)
  end

  def build_redirect_url(topic_id, name)
    "/learning-trails/#{topic_id}##{name}"
  end

  def create_user_lessons(topic)
    topic.lessons.find_each do |lesson|
      lesson.user_lessons.create(user_id: current_user.id,
                                 lesson_type: lesson.lesson_type,
                                 version: lesson.version)
    end
  end
end

