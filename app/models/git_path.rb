module GitPath
  def self.not_found(path, content_path, git)
    show(path, content_path, git)
    false
  rescue
    true
  end

  def self.found(path, content_path, git)
    !not_found(path, content_path, git)
  end

  def self.show(path, content_path, git)
    git.git.show(git.current_branch,
                 create_path(path, content_path))
  end

  def self.create_path(path, content_path)
    path.gsub("#{content_path}/", "")
  end
end
