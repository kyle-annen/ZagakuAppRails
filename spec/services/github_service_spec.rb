require 'rails_helper'

include GithubService

RSpec.describe GithubService do
  describe 'get_files' do
    it 'returns an array' do
      VCR.use_cassette('github_root') do
        repository_files = GithubService.get_files('kyle-annen/test-repo', '/')
        expect(repository_files).to be_a(Array)
      end
    end

    it 'returns an array of repo file objects which are all files' do
      VCR.use_cassette('github_root') do
        repository_files = GithubService.get_files('kyle-annen/test-repo', '/')
        repository_files.each do |file|
          expect(file.type).to eq('file')
        end
      end
    end

    describe 'get_contents' do
      it 'returns an array' do
        VCR.use_cassette('github_root') do
          result = GithubService.get_directory_contents('kyle-annen/test-repo', '/')
          expect(result).to be_a(Array)
        end
      end

      it 'returns the contents of a github repository path' do
        VCR.use_cassette('github_root') do
          result = GithubService.get_directory_contents('kyle-annen/test-repo', '/')
          expect(result.length).to be > 0
        end
      end
    end
  end

  describe 'files_not_resolved?' do
    it 'returns true if all objects in repo_list_array are files' do
      VCR.use_cassette('github_root') do
        resolved_contents = [
            double('Sawyer::Resource', type: 'file'),
            double('Sawyer::Resource', type: 'file'),
            double('Sawyer::Resource', type: 'file'),
            double('Sawyer::Resource', type: 'file')
        ]
        expect(GithubService.files_resolved?(resolved_contents)).to be(true)
      end
    end

    it 'returns false if all objecst in repo_list_array are not files' do
      VCR.use_cassette('github_root') do
        unresolved_contents = [
            double('Sawyer::Resource', type: 'file'),
            double('Sawyer::Resource', type: 'dir'),
            double('Sawyer::Resource', type: 'file'),
            double('Sawyer::Resource', type: 'file')
        ]
        expect(GithubService.files_resolved?(unresolved_contents)).to be(false)
      end
    end
  end
end
