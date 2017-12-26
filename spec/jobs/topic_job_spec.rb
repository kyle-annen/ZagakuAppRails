require 'rails_helper'

RSpec.describe TopicJob, type: :job do

  it 'Updates Categories, Topics, Levels, Tasks, and Goals' do
    allow_any_instance_of(GithubService).to receive(:get_files).and_return('')
    allow_any_instance_of(TopicService).to receive(:save_topics).and_return('')
    allow_any_instance_of(TopicContentService).to receive(:save_topic_content).and_return('')
    expect(GithubService).to receive(:get_files).with('kyle-annen/test-repo', '/')
    expect(TopicService).to receive(:save_topics)
    TopicJob.perform_now
  end
end
