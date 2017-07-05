require 'yaml'

#
# This class recursively crawls the content path
# starting the the current template paths folder and
# traversing each parent folder. Along the way it collects
# the configs specified in each folder and applies then to the
# vars instance variable, then recursively
# calls itself with the parent folders path creating a
# tree of scoped var resolvers along the way by loading
# the config.yml file from the current folder.
#
# Method missing is used to recursively call the parent objects
# looking for a var attribute containing the desired variable
# until the request variable is found on the tree or we hit the bottom
# of the tree.
#
class ScopedVarsResolver
  attr_accessor :vars, :parent, :hash, :current_path,
    :request, :paths, :child

  def initialize(request, paths, current_path)
    @request = request
    @paths = paths
    @current_path = current_path
    @child = false
    get_current_scope
    get_parent_scope
  end

  private

  # Setup the linked list of variable
  # trees for the file structure

  # Get the Yaml file for the current
  # file path depth
  def get_current_scope
    @vars = {}
    return unless File.file?(config_path)
    @vars = YAML.load_file(config_path)
  end

  def config_path
    File.join(current_path, 'configs.yml')
  end

  # Creates a linked list of parent variables
  # by recursively traversing the parent directories.
  def get_parent_scope
    puts "root #{root?}"
    puts "parent #{parent_path}"
    puts "root path #{@paths.content_root}"
    return if root?

    puts "Recurse"
    @parent = ScopedVarsResolver.new(request, paths, parent_path)
  end

  def root?
    File.identical?(parent_path, @paths.content_root)
  end

  def parent_path
    File.join(current_path, '..')
  end

  # Magic!
  # Return the request variable by walking the tree.
  # It is actually more like a linked list, but the variables
  # attribute could be traversed potentially...
  def method_missing(method_name, include_private = false)
    if @vars.has_key?(method_name.to_s)
      @vars[method_name.to_s]
    elsif parent
      parent.send(method_name)
    else
      super
    end
  end
end
