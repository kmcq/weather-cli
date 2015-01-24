# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "weathercli"
  gem.executables = ['weather']
  gem.homepage = "http://gitlab.com/kmcq/weathercli"
  gem.license = "MIT"
  gem.summary = "Weather updates on the command line."
  gem.description = "weathercli asks Yahoo for the current weather a few forecasts. You can have a default location or specify one when calling it."
  gem.authors = ["kmcq"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new
