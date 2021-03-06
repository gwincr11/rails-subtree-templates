require 'YAML'

class PagesController < ApplicationController

  helper PagesHelper

  def index

    # setup the needed path settings for content
    paths = PathResolver.new(request)
    set_branch
    # Setup the git branch tools
    @branches = Branches.new(paths, current_user, params, cookies)
    # custom git based template resolver
    @resolver = SubtreeResolver.new(@branches, paths)
    prepend_view_path @resolver


    # Set local vars
    @vars = ScopedVarsResolver
      .new(request, paths, paths.last_folder, @branches)

    allow_iframe
    render template: params[:page], layout: paths.layout_path
  end


  private

  def allow_iframe
    # If development or something else?
    response.headers.except! 'X-Frame-Options'
  end

  def set_branch
    if params["branches"] && params["branches"]["branch_select"]
      cookies[:branch] = params['branches']['branch_select']
    else
      cookies[:branch] = cookies.fetch(:branch, 'master')
    end
  end
end
