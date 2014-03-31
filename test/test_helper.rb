unless ARGV.any? {|e| e =~ /guard/ }
  require 'simplecov'
  SimpleCov.start('rails')
end

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

require 'greentable'

unless ARGV.any? {|e| e =~ /guard/ }
  require 'coveralls'
  Coveralls.wear!
end

public

def capture(&block)
  yield
end
