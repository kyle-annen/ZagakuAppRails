require 'rails_helper'
include TopicContentService
include TopicService

RSpec.describe TopicContentService do
  before(:each) do
    test_topics = [{
      name: 'clojure.md',
      path: 'language/clojure.md',
      sha: '6093e4475780d1bd154c37166dd3fa82d1e29525',
      size: 2035,
      url: '',
      html_url: '',
      git_url: '',
      download_url: '',
      type: 'file'
    }]
    TopicService.save_topics(test_topics)

    mock_topic_content = "# Clojure\n\nSummary.\n\n\n" +
        "## Level 1\n\n* task 1\n* task 2" +
        "### You should be able to\n\n* goal 1\n* goal 2\n" +
        "## Level 2\n\n* task 1\n* task 2" +
        "### You should be able to\n\n* goal 1\n* goal 2\n" +
        "## Level 3\n\n* task 1\n* task 2" +
        "### You should be able to\n\n* goal 1\n* goal 2\n"

    allow(TopicContentService)
      .to receive(:get_raw_content)
      .and_return(mock_topic_content)
  end

  after(:each) do
    Category.destroy_all
  end

  describe 'save_topic_content' do
    it 'saves the topic levels' do
      result = TopicContentService.save_topic_content(Topic.first)
      saved_topic_levels = TopicLevel.all
      expect(Topic.first.summary).to eq('Summary.')
      expect(saved_topic_levels.size).to eq(3)
      expect(saved_topic_levels.first.level_number).to eq(1)
      expect(TopicLevelTask.first.content).to eq("task 1")
      expect(TopicLevelTask.all.size).to eq(6)
      expect(TopicLevelGoal.first.content).to eq("goal 1")
      expect(TopicLevelGoal.all.size).to eq(6)
    end
  end
end
