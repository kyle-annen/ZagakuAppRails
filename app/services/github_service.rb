
module GithubService

  @client = Octokit::Client.new(
      access_token: ENV['GITHUB_TOKEN'],
      per_page: 100
  )

  @client.login

  def get_files(repo, start_path)
    get_directory_contents(repo, start_path)
      .flat_map { |o| resolve_contents(o, repo) }
  end

  def get_directory_contents(repository, repository_path)
    @client.contents(repository, path: repository_path)
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
    object.type == 'dir' ? get_directory_contents(repo, object.path) : object
  end
end
