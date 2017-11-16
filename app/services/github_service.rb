
module GithubService

  def ingest_repo
    root_contents = Octokit.content("8thlight/learning-trails", :path => "/")
    root_contents
  end
end