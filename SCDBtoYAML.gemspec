# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'SCDBtoYAML/version'

Gem::Specification.new do |gem|
  gem.name          = "SCDBtoYAML"
  gem.version       = SCDBtoYAML::VERSION
  gem.authors       = ["Kyle Mitchell"]
  gem.email         = ["kyle@blackacrelabs.org"]
  gem.description   = %q{Convert SCDB CSV files to YAML}
  gem.summary       = %q{Convert Supreme Court Database data files in CSV format into human-readable YAML files}
  gem.homepage      = "http://www.github.com/BlackacreLabs/scdbtoyaml"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'thor', '~> 0.16.0'
end
