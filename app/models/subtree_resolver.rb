require 'yaml'
require 'URI'

#
#
# A custom Rails template resolver that uses the
# setup paths objects content path to look for
# templates.
#
class SubtreeResolver < ActionView::Resolver
  attr_accessor :request, :content_paths

  def find_templates(name, prefix, partial, details, outside_app_allowed = false)
    format = details[:formats][0]
    requested = normalize_path(name, prefix)
    handlers = details[:handlers]
    collect_templates(requested, format, handlers)
  end

  def collect_templates(requested, format, handlers)
    TemplateCandidates.new(requested, format, handlers, content_paths.content_path)
      .find.map do |candidate_path|
      initialize_template(candidate_path)
    end
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
end

class TemplateCandidates
  attr_reader :requested, :format, :handlers, :content_path

  def initialize(requested, format, handlers, content_path)
    @requested = requested
    @format = format
    @handlers = handlers
    @content_path = content_path
  end

  def find
    potential_templates.map do |candidate_path|
      # Point to the symlinked file if it is a symlink.
      candidate_path = File.expand_path("#{content_path}/#{File.readlink(candidate_path)}") if File.symlink?(candidate_path)
      candidate_path
    end
  end

  private

  def potential_templates
    path = template_path
    paths = handlers
      .reject{|lang| !File.file?("#{path}.#{lang.to_s}") && !File.symlink?("#{path}.#{lang.to_s}") }
      .collect{|lang| "#{path}.#{lang.to_s}" }

    paths << path if File.exists?(path)
    paths
  end

  def template_path
    File.expand_path("#{content_path}/#{requested}.#{format}", __FILE__)
  end
end
