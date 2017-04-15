class PagesController < ActionController::Base
  include ActionController::Rendering
  include AbstractController::Helpers

  helper PagesHelper
  prepend_view_path SubtreeResolver.instance

  def index
    render template: params[:page]
  end
end
