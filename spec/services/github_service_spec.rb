require 'rails_helper'
include GithubService 

RSpec.describe GithubService do
  describe 'get_directory_contents' do
    it 'returns the contents of a github directory' do
      directory_contents = GithubService.get_directory_contents("kyle-annen/java-server", "/")
      expect(directory_contents.length).to be > 0
    end
  end
end