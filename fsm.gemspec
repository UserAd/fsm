# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fsm/version'

Gem::Specification.new do |spec|
  spec.name          = "fsm"
  spec.version       = Fsm::VERSION
  spec.authors       = ["Konstantin Tumalevich"]
  spec.email         = ["userad@gmail.com"]

  spec.summary       = %q{Simple FSM with events}
  spec.description   = %q{Yet another FSM with event emitter}
  spec.homepage      = "https://github.com/UserAd/fsm"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "event_emitter"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
