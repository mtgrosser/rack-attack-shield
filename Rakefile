require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test

namespace :shield do
  task :install do
    require 'rack/attack/shield'
    if defined?(Rails)
      file = Rails.root.join('app', 'views', 'layouts', 'shield.html')
      if file.exist?
        puts "skipping #{file}"
      else
        file.write(File)
    else
      
    end
  end
end
