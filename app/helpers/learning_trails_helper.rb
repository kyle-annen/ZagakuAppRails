module LearningTrailsHelper
  def get_topic_json(topic_id, user_id)
    topic = Topic.find(topic_id).as_json
    topic['levels'] = TopicLevel.where(topic_id: topic['id']).as_json
    topic['levels'].map do |level|
      level['tasks'] = Task.where(topic_level_id: level['id']).as_json
      level['goals'] = Goal.where(topic_level_id: level['id']).as_json
      level['tasks'].map do |task|
        task['complete'] = UserTask.where(user_id: user_id, task_id: task['id']).first[:complete]
        task['link'] = URI.extract(task['content']).first
      end
      level['goals'].map do |goal|
        goal['complete'] = UserGoal.where(user_id: user_id, goal_id: goal['id']).first[:complete]
        goal['link'] = URI.extract(goal['content']).first
      end
    end
    topic
  end

  def task_completion_percentage(topic_id, user_id)
    total = total_tasks(topic_id, user_id)
    completed = completed_tasks(topic_id, user_id)
    ((completed / total.to_f) * 100).round.to_s + '%'
  end

  def completed_tasks(topic_id, user_id)
    completed_tasks_query = <<-SQL
      SELECT count(*)
      FROM topic_levels
      LEFT JOIN tasks ON tasks.topic_level_id = topic_levels.id
      LEFT JOIN user_tasks ON tasks.id = user_tasks.task_id
      WHERE topic_levels.topic_id = #{topic_id}
      AND user_tasks.user_id = #{user_id}
      AND user_tasks.complete = 'true';
    SQL
    execute_task_sql(completed_tasks_query)
  end

  def total_tasks(topic_id, user_id)
    total_tasks_query = <<-SQL
      SELECT count(*)
      FROM topic_levels
      LEFT JOIN tasks ON tasks.topic_level_id = topic_levels.id
      LEFT JOIN user_tasks ON tasks.id = user_tasks.task_id
      WHERE topic_levels.topic_id = #{topic_id}
      AND user_tasks.user_id = #{user_id};
    SQL
    execute_task_sql(total_tasks_query)
  end

  private

  def execute_task_sql(query)
    ActiveRecord::Base
      .connection
      .execute(query)
      .first
      .values
      .flatten
      .first
      .to_i
  end
end
