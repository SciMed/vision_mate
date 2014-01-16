# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vision_mate/version'

Gem::Specification.new do |spec|
  spec.name          = "vision_mate"
  spec.version       = VisionMate::VERSION
  spec.authors       = ["Joe Jackson", "Joseph Jaber"]
  spec.email         = ["joe.jackson@scimedsolutions.com", "mail@josephjaber.com"]
  spec.summary       = %q{ Ruby client for the Thermo Scientific VisionMate 2D Scanner. }
  spec.description   = %q{ Ruby client for the Thermo Scientific VisionMate 2D Scanner. }
  spec.homepage      = "http://github.com/SciMed/vision_mate"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13"
  spec.add_development_dependency "yard"
end
