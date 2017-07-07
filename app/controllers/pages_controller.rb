require 'YAML'

class PagesController < ApplicationController
  @@resolver = SubtreeResolver.new

  helper PagesHelper
  prepend_view_path @@resolver


  def index
    # setup the needed path settings for content
    paths = PathResolver.new(request)
    set_branch
    # Setup the git branch tools
    @branches = Branches.new(paths, current_user, params, cookies)

    @@resolver.git = @branches
    @@resolver.request = request
    @@resolver.content_paths = paths

    # Set local vars
    @vars = ScopedVarsResolver
      .new(request, paths, paths.last_folder, @branches)

    render template: params[:page], layout: paths.layout_path
  end


  private

  def set_branch
    if params["branches"] && params["branches"]["branch_select"]
      cookies[:branch] = params['branches']['branch_select']
    else
      cookies[:branch] = cookies.fetch(:branch, 'master')
    end
  end
end
