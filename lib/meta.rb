class Meta
  def self.root_dir
    return @@root_dir if defined?(@@root_dir)

    @@lib_dir  ||= File.dirname(__FILE__)
    @@root_dir ||= File.dirname(@@lib_dir)
  end

  def self.data_dir
    @@data_dir ||= File.join(root_dir, 'data')
  end

  def self.brackets_dir
    @@brackets_dir ||= File.join(data_dir, 'brackets')
  end

  def self.teams_dir
    @@teams_dir ||= File.join(data_dir, 'teams')
  end
end
