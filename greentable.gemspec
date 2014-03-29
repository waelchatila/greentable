# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "greentable"
  spec.version     = "0.0.9"
  spec.authors       = ["Wael Chatila"]
  spec.email         = ["wchatila@book.com"]
  spec.description = "Greentable produces HTML tables from an array without you having to deal with any HTML elements."
  spec.summary     = "Rails declarative html tables with export features"
  spec.homepage    = "https://github.com/waelchatila/greentable"
  spec.license = 'LGPLv3+'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'coveralls'
end
