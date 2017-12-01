require 'rails_helper'
include TopicService

RSpec.describe TopicService do
  before(:each) do
    test_topics = [{
      name: 'testing.md',
      path: 'clean-code/testing.md',
      sha: '6093e4475780d1bd154c37166dd3fa82d1e29525',
      size: 2035,
      url: '',
      html_url: '',
      git_url: '',
      download_url: '',
      type: 'file'
    }]

    TopicService.save_topics(test_topics)
  end

  after(:each) do
    Category.destroy_all
  end

  describe 'save_topic' do
    it 'saves a topic and creates category if one does not exist' do
      expect(Topic.exists?(path: 'clean-code/testing.md')).to eq(true)
      expect(Category.exists?(category: 'clean-code')).to eq(true)
    end

    it 'updates a topic if it exists' do
      test_topics = [{
        name: 'testing.md',
        path: 'clean-code/testing.md',
        sha: '6093e4475780d1bd154c37166dd3fa82d1e29525',
        size: 2035,
        url: '',
        html_url: '',
        git_url: '',
        download_url: '',
        type: 'file'
      }]

      TopicService.save_topics(test_topics)
      updates_to_test_topics = [{
        name:  'testing.md',
        path: 'clean-code/testing.md',
        sha: '6093e4475780d1bd154c37166dd3fa82d1e29526',
        size: 2035,
        url: '',
        html_url: '',
        git_url: '',
        download_url: '',
        type: 'file'
      }]

      TopicService.save_topics(updates_to_test_topics)

      updated_topic = Topic.where(sha: updates_to_test_topics[0][:sha]).first

      expect(updated_topic[:sha]) .to eq(updates_to_test_topics[0][:sha])
    end
  end
end
