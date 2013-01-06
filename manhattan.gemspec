$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "manhattan/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  gem.name          = "manhattan"
  gem.version       = Manhattan::VERSION
  gem.authors       = ["Alvaro Pereyra"]
  gem.email         = ["alvaro@xendacentral.com"]
  gem.description   = "Easy way to define states on your classes"
  gem.summary       = "Extend your model with Manhattan, and enjoy a simple state machine and value accessors and queries"
  gem.homepage      = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.10"

  s.add_development_dependency "sqlite3"
end
