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

  end

  after(:each) do
    Category.destroy_all
  end

  describe 'save_topic_content' do
    mock_topic_content = "# Clojure\n\nSummary.\n\n\n" \
                         "## Level 1\n\n* task 1 http://test.com \n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n" \
                         "## Level 2\n\n* task 1\n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n" \
                         "# Level 3\n\n* task 1\n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n"\
                         '# Ongoing Reference'\
                         '* Read this book'

    it 'saves the topic summary on the topic' do
      TopicContentService.save_topic_content(Topic.first, mock_topic_content)
      expect(Topic.first.summary).to eq('Summary.')
    end

    it 'saves the lesson levels' do
      mock_topic_content = "# Clojure\n\nSummary.\n\n\n" \
                         "## Level 1\n\n* task 1 http://test.com \n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n" \
                         "## Level 2\n\n* task 1\n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n" \
                         "# Level 3\n\n* task 1\n* task 2" \
                         "### You should be able to\n\n* goal 1\n* goal 2\n"\
                         '# Ongoing Reference'\
                         '* Read this book'
      TopicContentService.save_topic_content(Topic.first, mock_topic_content)
      topic = Topic.first
      expect(topic.lessons.distinct.pluck(:level).size).to eq(4)
    end

    it 'saves the topic level tasks' do
      TopicContentService.save_topic_content(Topic.first, mock_topic_content)
      tasks = Lesson.where(lesson_type: 'task')
      expect(tasks.first.content).to eq('task 1 http://test.com')
      expect(tasks.size).to eq(6)
    end

    it 'saves the topic level goals' do
      TopicContentService.save_topic_content(Topic.first, mock_topic_content)
      goals = Lesson.where(lesson_type: 'goal')
      expect(goals.first.content).to eq('goal 1')
      expect(goals.all.size).to eq(6)
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

      TopicContentService.save_topic_content(Topic.first, mock_topic_content)
      TopicService.save_topics(test_topics_new_version)
      TopicContentService.save_topic_content(Topic.first, mock_topic_content)

      expect(Lesson.exists?(version: 0)).to eq(true)
      expect(Lesson.exists?(version: 1)).to eq(true)

      goals = Lesson.where(lesson_type: 'goal')
      expect(goals.exists?(version: 0)).to eq(true)
      expect(goals.exists?(version: 1)).to eq(true)

      tasks = Lesson.where(lesson_type: 'task')
      expect(tasks.exists?(version: 0)).to eq(true)
      expect(tasks.exists?(version: 1)).to eq(true)
    end

    it 'it saves ongoing references' do
      TopicContentService.save_topic_content(Topic.first, mock_topic_content)

      references = Lesson.where(lesson_type: 'reference')
      expect(references.first.version).to eq(0)
      expect(references.all.size).to eq(1)
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

      TopicContentService.save_topic_content(Topic.first, mock_topic_content)
      TopicService.save_topics(test_topics_no_new_version)
      TopicContentService.save_topic_content(Topic.first, mock_topic_content)

      goals = Lesson.where(lesson_type: 'goal')
      tasks = Lesson.where(lesson_type: 'task')

      expect(Lesson.exists?(version: 0)).to eq(true)
      expect(Lesson.exists?(version: 1)).to eq(false)
      expect(goals.exists?(version: 0)).to eq(true)
      expect(goals.exists?(version: 1)).to eq(false)
      expect(tasks.exists?(version: 0)).to eq(true)
      expect(tasks.exists?(version: 1)).to eq(false)
    end

    it 'saves a empty string for link_image and link_summary if there is no link' do
      TopicContentService.save_topic_content(Topic.first, mock_topic_content)
      tasks = Lesson.where(lesson_type: 'task')

      expect(tasks.first[:link_image]).to eq('')
      expect(tasks.first[:link_summary]).to eq('')
    end

    it 'parses the correct icon and images' do
      mock_website = '<!DOCTYPE html>' \
                   '<html lang="en">' \
                   '<meta nam="description" content="Test description" />' \
                   '<link rel="icon" href="test_favicon.ico" type="image/x-icon" />' \
                   '<head>' \
                   '</head>' \
                   '<body>' \
                   '<header class="site-header" role="banner">' \
                   '</header>' \
                   '<main class="page-content" aria-label="Content">' \
                   '<p>This is a test paragraph that should be sufficientlty long to trigger' \
                   'the metainspector to recognize as the description.</p>' \
                   '<img src="/assets/headache.jpg" alt="headache" />' \
                   '</main>' \
                   '</body>' \
                   '</html>'

      allow(MetaInspector)
        .to receive(:new)
        .and_return(
          MetaInspector.new('http://test.com', document: mock_website)
        )

      TopicContentService.save_topic_content(Topic.first, mock_topic_content)

      tasks = Lesson.where(lesson_type: 'task')
      expect(tasks.first[:link_image]).to eq('http://test.com/test_favicon.ico')
    end
  end
end
