require 'rails_helper'

RSpec.describe TopicJob, type: :job do
  it 'Updates Categories, Topics, Levels, Tasks, and Goals' do
    Category.create(category: 'test')
            .topics
            .create(category_id: 1,
                    name: 'test',
                    summary: 'test',
                    path: 'test',
                    version: 1,
                    sha: 'test',
                    size: 12,
                    url: 'test',
                    html_url: 'test',
                    git_url: 'test',
                    download_url: 'test',
                    github_type: 'file')

    allow_any_instance_of(GithubService)
      .to receive(:get_files)
      .and_return('')
    allow_any_instance_of(GithubService)
      .to receive(:get_raw_content)
      .and_return('')
    allow_any_instance_of(TopicService)
      .to receive(:save_topics)
      .and_return('')
    allow_any_instance_of(TopicContentService)
      .to receive(:save_topic_content)
      .and_return('')

    expect(GithubService)
      .to receive(:get_files)
      .with(ENV['LEARNING_TRAILS_REPO'], '/')

    expect(TopicService)
      .to receive(:save_topics)

    expect(TopicContentService)
      .to receive(:save_topic_content)
      .with(Topic.first, "")

    TopicJob.perform_now
  end
end
