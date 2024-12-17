class Meta
  def self.root_dir
    return @@root_dir if defined?(@@root_dir)

    @@lib_dir  ||= File.dirname(__FILE__)
    @@root_dir ||= File.dirname(@@lib_dir)
  end

  def self.data_dir
    @@data_dir ||= File.join(self.root_dir, 'data')
  end

  def self.brackets_dir
    @@data_dir ||= File.join(self.data_dir, 'brackets')
  end

  def self.teams
    @@data_dir ||= File.join(self.data_dir, 'teams')
  end
end
