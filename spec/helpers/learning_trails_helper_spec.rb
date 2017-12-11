require 'rails_helper'
include LearningTrailsHelper

RSpec.describe LearningTrailsHelper, type: :helper do
  describe 'get_topic_relation' do
    it 'returns the topic in a hash with levels/tasks/goals' do
      category = Category.create(category: 'clean-code')
      topic = category.topics.create(name: 'legacy-code.md',
                                     summary: 'summary',
                                     path: 'clean-code/legacy-code.md',
                                     sha: 'df0a42d82a29077385b1adbe44a05b7552d4ae8f',
                                     size: 901,
                                     url: '',
                                     html_url: '',
                                     git_url: '',
                                     download_url: '',
                                     github_type: 'file')

      level = topic.topic_levels.create([
                                          { level_number: 1, version: 0 },
                                          { level_number: 2, version: 0 }
                                        ])
      TopicLevel.all.each do |level|
        level.topic_level_tasks.create([{ content: 'number 1', version: 0 }])
        level.topic_level_goals.create([{ content: 'get thru it', version: 0 }])
      end
      result = LearningTrailsHelper.get_topic_relation(1)
      expect(result.class).to eq(Hash)
      expect(result['id']).to eq(1)
      expect(Topic.all.count).to eq(1)
    end
  end
end
