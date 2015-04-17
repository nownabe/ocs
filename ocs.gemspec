# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ocs/version'

Gem::Specification.new do |spec|
  spec.name          = "ocs"
  spec.version       = Ocs::VERSION
  spec.authors       = ["nownabe"]
  spec.email         = ["nownabe@gmail.com"]

  spec.summary       = %q{Ocs is an objective CloudStack API client.}
  spec.homepage      = "https://github.com/nownabe/ocs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "memoist"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
