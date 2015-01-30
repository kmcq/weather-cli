# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: weathercli 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "weathercli"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["kmcq"]
  s.date = "2015-01-30"
  s.description = "weathercli asks Yahoo for the current weather and a few forecasts. You can have a default location or specify one when calling it."
  s.executables = ["weather"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/weather",
    "lib/weathercli.rb",
    "lib/weathercli/cli.rb",
    "lib/weathercli/weather.rb",
    "license.md",
    "spec/cli_spec.rb",
    "spec/spec_helper.rb",
    "spec/weather_spec.rb",
    "weathercli.gemspec"
  ]
  s.homepage = "http://gitlab.com/kmcq/weathercli"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.3.0"
  s.summary = "Weather updates on the command line."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, ["= 3.1.0"])
      s.add_runtime_dependency(%q<json>, ["= 1.8.2"])
      s.add_development_dependency(%q<jeweler>, ["= 2.0.1"])
    else
      s.add_dependency(%q<rspec>, ["= 3.1.0"])
      s.add_dependency(%q<json>, ["= 1.8.2"])
      s.add_dependency(%q<jeweler>, ["= 2.0.1"])
    end
  else
    s.add_dependency(%q<rspec>, ["= 3.1.0"])
    s.add_dependency(%q<json>, ["= 1.8.2"])
    s.add_dependency(%q<jeweler>, ["= 2.0.1"])
  end
end

