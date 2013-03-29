$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fcrepo_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fcrepo_admin"
  s.version     = FcrepoAdmin::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "http://projecthydra.org"
  s.summary     = "TODO: Summary of Blorgh."
  s.description = "TODO: Description of Blorgh."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "hydra-head", "6.0.0"
  s.add_dependency "blacklight"
  s.add_dependency "rails", "~> 3.2.13"

  s.add_dependency "rubyzip"
  s.add_dependency "paperclip", '~> 3.1'
  s.add_dependency "mini_magick"
  s.add_dependency "mime-types", '~> 1.19'
  s.add_development_dependency "devise"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "sqlite3"
end