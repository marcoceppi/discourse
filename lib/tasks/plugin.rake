require 'grit'
include Grit

directory 'plugins"'

desc 'install plugin for discourse'
task 'plugin:install' do |t|
  repo = ENV['REPO'] || ENV['repo']
  name = ENV['NAME'] || ENV['name']
  if name.nil?
    name = File.basename(repo, '.git')
  end

  plugin_path = File.expand_path('plugins/' + name)
  if File.directory?(File.expand_path(plugin_path))
   abort('Plugin directory, ' + plugin_path + ', already exists.')
  end

  clone_status = system('git clone ' + repo + ' ' + plugin_path)
  unless clone_status
    FileUtils.rm_rf(plugin_path)
    abort('Unable to clone plugin')
  end
end

desc 'update all plugins'
task 'plugin:update_all' do |t|
  # Loop through each directory, run plugin:update
  plugins = Dir.glob(File.expand_path('plugins/*')).select {|f| File.directory? f}
  plugins.each { |plugin| Rake::Task['plugin:update'].invoke(plugin) }
end

desc 'update a plugin'
task 'plugin:update', :plugin do |t, args|
  plugin = ENV['PLUGIN'] || ENV['plugin'] || args[:plugin]
  plugin_path = plugin
  plugin = File.basename(plugin)

  unless File.directory?(plugin_path)
    if File.directory?('plugins/' + plugin)
      plugin_path = File.expand_path('plugins/' + plugin)
    else
      abort('Plugin ' + plugin + ' not found')
    end
  end

  update_status = system('git --git-dir "' + plugin_path + '/.git" --work-tree "' + plugin_path + '" pull')
  unless update_status
    abort('Unable to pull latest version of plugin')
  end
end
