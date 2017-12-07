require 'rails_helper'
include TopicService

RSpec.describe TopicService do
  before(:each) do
    test_topics = [{
      name: 'vim.md',
      path: 'tools/vim.md',
      sha: '709a244b24b8109b1080e235365f44d67a8f071f',
      size: 1870,
      url: 'https://api.github.com/repos/kyle-annen/test-repo/contents/tools/vim.md?ref=master',
      html_url: 'https://github.com/kyle-annen/test-repo/blob/master/tools/vim.md',
      git_url: 'https://api.github.com/repos/kyle-annen/test-repo/git/blobs/709a244b24b8109b1080e235365f44d67a8f071f',
      download_url: 'https://raw.githubusercontent.com/kyle-annen/test-repo/master/tools/vim.md',
      type: 'file',
      _links: {
        self: 'https://api.github.com/repos/kyle-annen/test-repo/contents/tools/vim.md?ref=master',
        git: 'https://api.github.com/repos/kyle-annen/test-repo/git/blobs/709a244b24b8109b1080e235365f44d67a8f071f',
        html: 'https://github.com/kyle-annen/test-repo/blob/master/tools/vim.md'
      }
    }]

    TopicService.save_topics(test_topics)
  end

  after(:each) do
    Category.destroy_all
  end

  describe 'save_topic' do
    it 'saves a topic and creates category if one does not exist' do
      expect(Topic.exists?(path: 'tools/vim.md')).to eq(true)
      expect(Category.exists?(category: 'tools')).to eq(true)
    end

    it 'updates a topic if it exists, and increments version number' do
      updates_to_test_topics = [{
        name: 'vim.md',
        path: 'tools/vim.md',
        sha: 'new-sha234234lk2j3l4kj',
        size: 1870,
        url: 'https://api.github.com/repos/kyle-annen/test-repo/contents/tools/vim.md?ref=master',
        html_url: 'https://github.com/kyle-annen/test-repo/blob/master/tools/vim.md',
        git_url: 'https://api.github.com/repos/kyle-annen/test-repo/git/blobs/709a244b24b8109b1080e235365f44d67a8f071f',
        download_url: 'https://raw.githubusercontent.com/kyle-annen/test-repo/master/tools/vim.md',
        type: 'file',
        _links: {
          self: 'https://api.github.com/repos/kyle-annen/test-repo/contents/tools/vim.md?ref=master',
          git: 'https://api.github.com/repos/kyle-annen/test-repo/git/blobs/709a244b24b8109b1080e235365f44d67a8f071f',
          html: 'https://github.com/kyle-annen/test-repo/blob/master/tools/vim.md'
        }
      }]

      path = updates_to_test_topics[0][:path]
      expect(Topic.where(path: path).max_by(&:version).version).to eq(0)

      TopicService.save_topics(updates_to_test_topics)
      updated_topic = Topic.where(sha: updates_to_test_topics[0][:sha]).first

      expect(updated_topic[:sha]) .to eq(updates_to_test_topics[0][:sha])
      expect(updated_topic.version).to eq(1)
    end
  end
end
