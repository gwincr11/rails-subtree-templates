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

  def initialize(path)
    @path = path
    @git = Git.open(path)
    @branches = @git.branches.remote
    @current_branch = @git.current_branch
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
end
