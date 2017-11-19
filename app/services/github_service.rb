
module GithubService
  @user = 'kyle-annen'

  def get_files(repo, start_path)
    get_contents(repo, start_path)
        .flat_map { |o| resolve_contents(o, repo) }
  end



  def get_contents(repository, repository_path)
    client = Octokit::Client.new(
        :client_id => ENV['GITHUB_CLIENT_ID'],
        :client_secret => ENV['GITHUB_CLIENT_SECRET'])
    user = client.user @user
    client.contents(repository, :path => repository_path)
  end

  def files_resolved?(repo_listing_array)
    results = []
    repo_listing_array.each do |listing|
      results << (listing.type == 'file')
    end
    results.inject(true) { |x, y| x && y }
  end

  private
    def resolve_contents(object, repo)
      object.type == 'dir' ? get_contents(repo, object.path) : object
    end
end
