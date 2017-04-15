class PagesController < ApplicationController
  prepend_view_path SubtreeResolver.new

  def index
    render template: params[:page]
  end
end
