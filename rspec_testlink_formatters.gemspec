# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_testlink_formatters/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_testlink_formatters"
  spec.version       = RspecTestlinkFormatters::VERSION
  spec.authors       = ["Pim Snel"]
  spec.email         = ["pim@lingewoud.nl"]
  spec.summary       = %q{Formatters for communicating with TestLink}
  spec.description   = %q{Formatter for importing testcases into testlink, and formatter for updating testlink with jenkins testlink plugin}
  spec.homepage      = "https://github.com/mipmip/rspec_testlink_formatters.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'testlink_rspec_utils', '~> 0.0.3'
  spec.add_dependency "rspec-core", "~> 3.1.0"
end
