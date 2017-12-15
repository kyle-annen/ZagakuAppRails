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

    mock_topic_content = "# Clojure\n\nSummary.\n\n\n" \
                         "## Level 1\n\n* task 1\n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n" \
                         "## Level 2\n\n* task 1\n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n" \
                         "# Level 3\n\n* task 1\n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n"\
                         "# Ongoing Reference"\
                         "* Read this book"



    allow(TopicContentService)
      .to receive(:get_raw_content)
      .and_return(mock_topic_content)
  end

  after(:each) do
    Category.destroy_all
  end

  describe 'save_topic_content' do
    it 'saves the topic levels' do
      TopicContentService.save_topic_content(Topic.first)
      saved_topic_levels = TopicLevel.all
      expect(Topic.first.summary).to eq('Summary.')
      expect(saved_topic_levels.size).to eq(3)
      expect(saved_topic_levels.first.level_number).to eq(1)
    end

    it 'saves the topic level tasks' do
      TopicContentService.save_topic_content(Topic.first)
      expect(Task.first.content).to eq('task 1')
      expect(Task.all.size).to eq(6)
    end

    it 'saves the topic level goals' do
      TopicContentService.save_topic_content(Topic.first)
      expect(Goal.first.content).to eq('goal 1')
      expect(Goal.all.size).to eq(6)
    end

    it 'saves new version of goals, levels, and tasks on new version topic' do
      test_topics_new_version = [{
        name: 'clojure.md',
        path: 'language/clojure.md',
        sha: 'newsha',
        size: 2035,
        url: '',
        html_url: '',
        git_url: '',
        download_url: '',
        type: 'file'
      }]

      TopicContentService.save_topic_content(Topic.first)
      TopicService.save_topics(test_topics_new_version)
      TopicContentService.save_topic_content(Topic.first)

      expect(TopicLevel.exists?(version: 0)).to eq(true)
      expect(TopicLevel.exists?(version: 1)).to eq(true)
      expect(Goal.exists?(version: 0)).to eq(true)
      expect(Goal.exists?(version: 1)).to eq(true)
      expect(Task.exists?(version: 0)).to eq(true)
      expect(Task.exists?(version: 1)).to eq(true)
    end

    it 'it saves ongoing references' do

    end

    it 'does not save new versions when provided and old version topic' do
      test_topics_no_new_version = [{
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

      TopicContentService.save_topic_content(Topic.first)
      TopicService.save_topics(test_topics_no_new_version)
      TopicContentService.save_topic_content(Topic.first)

      expect(TopicLevel.exists?(version: 0)).to eq(true)
      expect(TopicLevel.exists?(version: 1)).to eq(false)
      expect(Goal.exists?(version: 0)).to eq(true)
      expect(Goal.exists?(version: 1)).to eq(false)
      expect(Task.exists?(version: 0)).to eq(true)
      expect(Task.exists?(version: 1)).to eq(false)
    end
  end
end
