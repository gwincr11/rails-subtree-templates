require 'yaml'
require 'URI'

#
#
# A custom Rails template resolver that uses the
# setup paths objects content path to look for
# templates.
#
class SubtreeResolver < ActionView::Resolver
  attr_accessor :request, :content_paths, :git

  def initialize(git, paths)
    @git = git
    @content_paths = paths
    super()
  end


  def find_templates(name, prefix, partial,
                     details, outside_app_allowed = false)
    format = details[:formats][0]
    requested = normalize_path(name, prefix)
    handlers = details[:handlers]
    collect_templates(requested, format, handlers)
  end

  def collect_templates(requested, format, handlers)
    TemplateCandidates.new(requested, format, handlers, content_paths.content_path, git)
      .find.map do |candidate_path|
      initialize_template(candidate_path)
    end
  end

  # Initialize an ActionView::Template object based on the record found.
  def initialize_template(path)
    source = GitPath.show(path, content_paths.content_path, @git)
    source = follow_symlink(source)

    identifier = path
    handler = path.split('.').last
    handler = ActionView::Template.registered_template_handler(handler)

    details = {
      format: Mime['html'],
      updated_at: Date.today,
      virtual_path: path
    }

    ActionView::Template.new(source, identifier, handler, details)
  end

  def follow_symlink(source)
    Pathname.new(source)
    GitPath.show(source, content_paths.content_path, @git)
  rescue
    source
  end

  # Normalize name and prefix, so the tuple ["index", "users"] becomes
  # "users/index" and the tuple ["template", nil] becomes "template".
  def normalize_path(name, prefix)
    prefix.present? ? "#{prefix}/#{name}" : name
  end
end

class TemplateCandidates
  attr_reader :requested, :format, :handlers, :content_path

  def initialize(requested, format, handlers, content_path, git)
    @requested = requested
    @format = format
    @handlers = handlers
    @git = git
    @content_path = content_path
  end

  def find
    potential_templates
  end

  private

  def potential_templates
    paths = collect_templates(template_path)
    paths.concat collect_templates(template_path_no_ext)
  end


  def collect_templates(path)
    paths = handlers
      .reject{|lang| not_found("#{path}.#{lang.to_s}") }
      .collect{|lang| "#{path}.#{lang.to_s}" }

    paths << path if !not_found(path)
    paths
  end

  def not_found(path)
    GitPath.not_found(path, @content_path, @git)
  end

  def template_path_no_ext
    File.expand_path("#{content_path}/#{requested}", __FILE__)
  end

  def template_path
    "#{template_path_no_ext}.#{format}"
  end
end


