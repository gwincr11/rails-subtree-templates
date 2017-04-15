class SubtreeResolver < ActionView::Resolver
  def find_templates(name, prefix, partial, details, outside_app_allowed = false)
    puts name
    puts prefix
    puts partial
    puts details
    format = details[:formats][0]
    requested = normalize_path(name, prefix)
    path = File.expand_path("../../subtree-views/#{requested}.#{format}", __FILE__)
    puts path
    return [] unless File.exists?(path)
    file = File.binread(path)
    [initialize_template(file, path)]
  end

  # Initialize an ActionView::Template object based on the record found.
  def initialize_template(body, path)
    source = body
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


end
