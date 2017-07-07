#
# A form object that looks in the
# specified git repo and sets up
# variable of the current branches on
# that repo and also allows for changing
# branches.
#
class Branches
  include ActiveModel::Model

  attr_accessor :branches, :current_branch, :current_sha, :git

  def initialize(path, user, params, cookies)
    @path = path
    @git = Git.open(@path.content_path)
    @params = params
    @branches = find_visible_branches(user)
    @current_branch = cookies[:branch]
    @current_sha = @git.branch(@current_branch).gcommit.sha
  end

  def edit_path
    "#{@git.remote('origin').url}/blob/#{current_branch}/#{file_path}"
  end

  def branch_names
    branches.collect { |b| b.name }
  end

  def branch_select
    branches.collect { |b| [b.name, b.name] }
  end

  def checkout(br)
    @git.fetch
    @git.checkout(br)
    @current_branch = @git.current_branch
  end

  def can_view_branches?(user)
    return false unless user
    client = Octokit::Client.new(login: ENV['OCTOKIT_LOGIN'], access_token: ENV['OCTOKIT_TOKEN'])
    repo = Octokit::Repository.from_url(@git.remote.url)
    client.collaborator?(repo, user.login)
  end

  private

  def file_path
    path = @params.fetch(:page, 'index')
    puts path
    template = TemplateCandidates
      .new(path, 'html', [:erb, :md], @path.content_path, self).find[0]
    template.gsub(@path.content_path, '')
  end

  def find_visible_branches(user)
    return [] unless can_view_branches?(user)
    all_branches = @git.branches.remote
  end
end
