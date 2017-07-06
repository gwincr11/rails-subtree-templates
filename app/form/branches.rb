#
# A form object that looks in the
# specified git repo and sets up
# variable of the current branches on
# that repo and also allows for changing
# branches.
#
class Branches
  include ActiveModel::Model

  attr_accessor :branches, :current_branch

  def initialize(path, params)
    @path = path
    @git = Git.open(@path.content_path)
    @params = params
    set_branch(params)
    @branches = @git.branches.remote
    @current_branch = @git.current_branch
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

  private

  def file_path
    path = @params.fetch(:page, 'index')
    template = TemplateCandidates
      .new(path, 'html', [:erb], @path.content_path).find[0]
    template.gsub(@path.content_path, '')
  end

  def set_branch(params)
    if params["branches"] && params["branches"]["branch_select"]
      checkout params["branches"]["branch_select"]
    end
  end
end
