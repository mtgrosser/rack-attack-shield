require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

task :default => :test

namespace :rack do
  namespace :shield do
    task :install do
      require 'rack/shield'
      file = defined?(Rails) ? Rails.root.join('app', 'views', 'layouts', 'shield.html') : 'shield.html'
      if file.exist?
        puts "skipping #{file}"
      else
        file.write(Rack::Shield::Response.default_template.read)
        puts "create #{file}"
      end
    end
  end
end
