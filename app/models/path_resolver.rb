require 'yaml'

#
# Setup all the paths used to fetch content and
# layouts for the app based on the domain and
# the config files.
class PathResolver
  attr_accessor :content_path, :layout_path, :domain, :request

  def initialize(request)
    @domain = request.domain
    @request = request
    get_content_path
    get_layout_path
  end

  def content_root
    path = File.expand_path("../../../content/", __FILE__)
    path = "#{path}/#{domain}"
    path
  end

  # Return the last folder in the content path
  def last_folder
    return content_path unless request.params.has_key?("page")
    path = request.params["page"].split('/')
    File.join(content_path, path[0..-2])
  end

  private

  def get_content_path
    uri = configs["domains"][domain]["content_repo"]
    folder = URI(uri).path.split('/').last

    @content_path = File.join(content_root, folder)
  end

  def get_layout_path
    uri = configs["domains"][domain]["layout_repo"]
    repo = URI(uri).path.split('/').last

    @layout_path = "#{domain}/#{repo}/application.html.erb"
  end

  def configs
    @configs ||= YAML.load_file("domains.yml")
  end
end
