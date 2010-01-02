#!/usr/bin/env ruby

home = ENV['HOME']

Dir.chdir File.dirname(__FILE__) do
  dotfiles_dir = Dir.pwd.sub(home + '/', '')

  Dir['*'].each do |file|
    next if file == 'bash' || file == 'install.rb'

    target_name = file == 'bin' ? file : ".#{file}"
    target      = File.join(home, target_name)

    if File.exist? target
      puts "Exists: #{target}"
      next
    end

    system %[ln -vsf #{File.join(dotfiles_dir, file)} #{target}]
  end
end
