Gem::Specification.new do |s|
  s.name        = "greentable"
  s.version     = "0.0.2"
  s.author      = "Wael Chatila"
  s.summary     = "Rails declarative html tables with export (xls,csv) features"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  #s.add_dependency 'name', 'version'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'testunit'
end
