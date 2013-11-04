Gem::Specification.new do |s|
  s.name        = "greentable"
  s.version     = "0.0.8"
  s.author      = "Wael Chatila"
  s.homepage    = "https://github.com/waelchatila/greentable"
  s.summary     = "Rails declarative html tables with export features"
  s.description = "Greentable produces HTML tables from an array without you having to deal with any HTML elements."
  s.license = 'LGPLv3+'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  #s.add_dependency 'name', 'version'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'testunit'
end
