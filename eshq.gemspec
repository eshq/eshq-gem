# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "eshq/version"

Gem::Specification.new do |s|
  s.name        = "eshq"
  s.version     = ESHQ::VERSION
  s.authors     = ["Mathias Biilmann Christensen"]
  s.email       = ["mathiasch@eventsourcehq.com"]
  s.homepage    = ""
  s.summary     = %q{EventSource HQ API Client}
  s.description = ""

  s.rubyforge_project = "eshq"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "mocha"
  s.add_development_dependency "timecop"
  s.add_development_dependency "fakeweb"

  s.add_runtime_dependency "json"
end
