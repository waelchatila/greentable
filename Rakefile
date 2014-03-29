require "bundler/gem_tasks"
require 'rake/testtask'
#require 'coveralls/rake/task'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

#Coveralls::RakeTask.new
#task :test_with_coveralls => [:test, :features, 'coveralls:push']