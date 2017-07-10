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
    uri = configs(domain)["content_repo"]
    folder = URI(uri).path.split('/').last

    @content_path = File.join(content_root, folder)
  end

  def get_layout_path
    uri = configs(domain)["layout_repo"]
    repo = URI(uri).path.split('/').last

    @layout_path = "#{domain}/#{repo}/application.html.erb"
  end


  def configs(domain)
    DomainConfigs.configs(domain)
  end
end

module DomainConfigs
  #
  # SSO will not work with this because of the different domain?
  #
  def self.configs(domain)
    configs = YAML.load_file("domains.yml")['domains']
    domain_configs =configs[domain]
    if domain_configs.has_key?('alias')
      alias_domain = domain_configs['alias']
      domain_configs = configs[alias_domain]
    end
    domain_configs
  end
end
