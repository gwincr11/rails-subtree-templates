require 'YAML'

class PagesController < ActionController::Base
  include ActionController::Rendering
  include AbstractController::Helpers

  @@resolver = SubtreeResolver.new

  helper PagesHelper
  prepend_view_path @@resolver

  def index
    @var1 = 'hello'
    @@resolver.request = request
    @branches = ::Branches
      .new(File.expand_path("content/content_test1"))
    if params["branches"] && params["branches"]["branch_select"]
      @branches.checkout params["branches"]["branch_select"]
    end
    render template: params[:page], layout: get_layout
  end

  private

  def get_layout
    configs = YAML.load_file('domains.yml')
    domain = request.host
    uri = configs["domains"][domain]["layout_repo"]
    repo = URI(uri).path.split('/').last

    "#{domain}/#{repo}/application.html.erb"
  end
end
