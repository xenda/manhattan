# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'manhattan/version'

Gem::Specification.new do |gem|
  gem.name          = "manhattan"
  gem.version       = Manhattan::VERSION
  gem.authors       = ["Alvaro Pereyra"]
  gem.email         = ["alvaro@xendacentral.com"]
  gem.description   = "Easy way to define states on your classes"
  gem.summary       = "Extend your model with Manhattan, and enjoy a simple state machine and value accessors and queries"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
