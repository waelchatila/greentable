Gem::Specification.new do |s|
  s.name        = "greentable"
  s.version     = "0.0.3"
  s.author      = "Wael Chatila"
  s.homepage    = "https://github.com/waelchatila/greentable"
  s.summary     = "Rails declarative html tables with export features"
  s.description = "Rails declarative html tables with export features"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  #s.add_dependency 'name', 'version'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'testunit'
end