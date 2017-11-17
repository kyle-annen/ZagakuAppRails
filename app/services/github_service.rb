
module GithubService
  def get_directory_contents(repository, repository_path)
    client = Octokit::Client.new \
      :client_id => ENV['GITHUB_CLIENT_ID'],
      :client_secret => ENV['GITHUB_CLIENT_SECRET']
    user = client.user 'kyle-annen'
    Octokit.contents(repository, :path => repository_path)
  end
end