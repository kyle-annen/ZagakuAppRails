require 'rails_helper'

RSpec.describe TopicJob, type: :job do
  it 'Updates Categories, Topics, Levels, Tasks, and Goals' do
    VCR.use_cassette('topic_job') do
      expect(Category.all.size).to eq(0)
      expect(Topic.all.size).to eq(0)
      expect(TopicLevel.all.size).to eq(0)
      expect(Task.all.size).to eq(0)
      expect(Goal.all.size).to eq(0)

      TopicJob.new.perform

      expect(Category.all.size).to be > 0
      expect(Topic.all.size).to be > 0
      expect(TopicLevel.all.size).to be > 0
      expect(Task.all.size).to be > 0
      expect(Goal.all.size).to be > 0
    end
  end
end
