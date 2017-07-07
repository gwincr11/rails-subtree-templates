# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

require 'pathname'
require 'yaml'

Rails.application.load_tasks

DOMAINS_CONFIG_FILE = './domains.yml'.freeze
CONTENT_FOLDER      = './content'.freeze

desc 'Creates or updates domains configured in domains.yml'
task :create_update_domains do
  domains = YAML.load_file(DOMAINS_CONFIG_FILE)['domains']
  content = Pathname.new(CONTENT_FOLDER)

  domains.each do |domain, repos|
    next if repos.has_key? 'alias'
    domain_dir  = content + domain
    content_dir = domain_dir + URI.parse(repos['content_repo']).path.split('/').last

    domain_dir.mkpath

    if content_dir.exist?
      Dir.chdir(content_dir.realdirpath) do
        system 'git pull'
      end
    else
      `git clone #{repos['content_repo']} #{content_dir}` unless content_dir.exist?
    end
  end
end
