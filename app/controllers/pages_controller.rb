require 'YAML'

class PagesController < ApplicationController
  @@resolver = SubtreeResolver.new

  helper PagesHelper
  prepend_view_path @@resolver


  def index
    #git show test1:index.html.erb
    # setup the needed path settings for content
    puts params[:page]
    paths = PathResolver.new(request)
    # Setup the git branch tools
    @branches = Branches.new(paths, current_user, params)

    @@resolver.request = request
    @@resolver.content_paths = paths

    # Set local vars
    @vars = ScopedVarsResolver.new(request, paths, paths.last_folder)

    render template: params[:page], layout: paths.layout_path
  end
end
