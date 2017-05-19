require 'yaml'
require 'URI'

class SubtreeResolver < ActionView::Resolver
  attr_accessor :request

  def find_templates(name, prefix, partial, details, outside_app_allowed = false)
    format = details[:formats][0]
    requested = normalize_path(name, prefix)

    folder = content_folder_for(request.domain)
    path = File.expand_path("../../../content/#{request.domain}/#{folder}/#{requested}.#{format}", __FILE__)
    (1..4).reject{|x| x == 3}.collect{|x| x + 1}
    paths = details[:handlers].reject{|lang| !File.exists?("#{path}.#{lang.to_s}") }
      .collect{|lang| "#{path}.#{lang.to_s}" }

    paths << path if File.exists?(path)
    paths.map { |candidate_path| initialize_template(candidate_path) }
  end

  # Initialize an ActionView::Template object based on the record found.
  def initialize_template(path)
    source = File.binread(path)
    identifier = path
    handler = ActionView::Template.registered_template_handler('erb')

    details = {
      format: Mime['html'],
      updated_at: File.mtime(path),
      virtual_path: path
    }

    ActionView::Template.new(source, identifier, handler, details)
  end

  # Normalize name and prefix, so the tuple ["index", "users"] becomes
  # "users/index" and the tuple ["template", nil] becomes "template".
  def normalize_path(name, prefix)
    prefix.present? ? "#{prefix}/#{name}" : name
  end

  # Normalize arrays by converting all symbols to strings.
  def normalize_array(array)
    array.map(&:to_s)
  end

  def content_folder_for(domain)
    configs = YAML.load_file("domains.yml")

    uri = configs["domains"][domain]["content_repo"]
    URI(uri).path.split('/').last
  end
end
