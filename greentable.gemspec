$:.push File.expand_path("../lib", __FILE__)

require "greentable/version"

Gem::Specification.new do |spec|
  spec.name          = "greentable"
  spec.version     = Greentable::VERSION
  spec.authors       = ["Wael Chatila"]
  spec.description = "Greentable automatically produces HTML tables from an array in a succinct way. It also provides an easy way to export and print a particular table"
  spec.summary     = "Rails declarative html tables with export and print features"
  spec.homepage    = "https://github.com/waelchatila/greentable"
  spec.license = 'LGPLv3+'

  spec.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.test_files = Dir["test/**/*"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rails", "~> 3.2.17"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "fastercsv"
  spec.add_development_dependency "guard-test"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end



