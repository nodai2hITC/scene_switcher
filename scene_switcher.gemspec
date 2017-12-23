
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "scene_switcher/version"

Gem::Specification.new do |spec|
  spec.name          = "scene_switcher"
  spec.version       = SceneSwitcher::VERSION
  spec.authors       = ["nodai2hITC"]
  spec.email         = ["nodai2h.itc@gmail.com"]
  
  spec.summary       = %q{Switch scene easily.}
  spec.description   = %q{Switch scene easily.}
  spec.homepage      = "https://github.com/nodai2hITC/scene_switcher"
  spec.license       = "MIT"
  
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
