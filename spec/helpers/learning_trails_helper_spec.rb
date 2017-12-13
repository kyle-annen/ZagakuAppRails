require 'rails_helper'
include LearningTrailsHelper

RSpec.describe LearningTrailsHelper, type: :helper do
  describe 'get_topic_json' do
    it 'returns the topic in a hash with levels/tasks/goals' do
      category = Category.create(category: 'clean-code')
      topic = category.topics.create(
        name: 'legacy-code.md',
        summary: 'summary',
        path: 'clean-code/legacy-code.md',
        sha: 'df0a42d82a29077385b1adbe44a05b7552d4ae8f',
        size: 901,
        url: '',
        html_url: '',
        git_url: '',
        download_url: '',
        github_type: 'file'
      )

      level = topic.topic_levels.create(
        [
          { level_number: 1, version: 0 },
          { level_number: 2, version: 0 }
        ]
      )

      TopicLevel.all.each do |topic_level|
        topic_level.tasks.create([{ content: 'number http://google.com) 1', version: 0 }])
        topic_level.goals.create([{ content: 'get thru it (/legacy-code.md) ', version: 0 }])
      end

      UserTask.create(
        [
          { user_id: 1, task_id: 1 },
          { user_id: 1, task_id: 2 }
        ]
      )

      UserGoal.create(
        [
          { user_id: 1, goal_id: 1 },
          { user_id: 1, goal_id: 2 }
        ]
      )

      result = LearningTrailsHelper.get_topic_json(1, 1)

      expect(result.class).to eq(Hash)
      expect(result['id']).to eq(1)
      expect(Topic.all.count).to eq(1)
      expect(result['levels'].size).to eq(2)
      expect(result['levels'][0]['tasks'].length).to eq(1)
      expect(result['levels'][1]['tasks'].length).to eq(1)
      expect(result['levels'][0]['goals'].length).to eq(1)
      expect(result['levels'][1]['goals'].length).to eq(1)
      expect(result['levels'][0]['tasks'][0]['link']).to eq('http://google.com')
      expect(result['levels'][0]['goals'][0]['link']).to eq(nil)

    end
  end
end