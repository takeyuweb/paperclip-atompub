$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "paperclip-atompub/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "paperclip-atompub"
  s.version     = PaperclipAtompub::VERSION
  s.authors     = ["Yuichi Takeuchi"]
  s.email       = ["uzuki05@takeyu-web.com"]
  s.homepage    = "https://github.com/uzuki05/paperclip-atompub"
  s.summary     = "Adds Atompub Media Resource strage support for the Paperclip"
  s.description = "Adds Atompub Media Resource strage support for the Paperclip"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"
  s.add_dependency "paperclip", "~> 3.0"
  s.add_dependency "atomutil"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "settingslogic"
end
