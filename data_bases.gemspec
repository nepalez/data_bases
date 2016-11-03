Gem::Specification.new do |gem|
  gem.name     = "data_bases"
  gem.version  = "0.0.1"
  gem.author   = ["Andrew Kozin"]
  gem.email    = ["nepalez@evilmartians.com"]
  gem.homepage = "https://github.com/nepalez/data_bases"
  gem.summary  = "Supports several databases inside single Rails application."
  gem.license  = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = gem.files.grep(/^spec/)
  gem.extra_rdoc_files = Dir["README.md", "LICENSE", "CHANGELOG.md"]

  gem.required_ruby_version = ">= 2.2"

  gem.add_runtime_dependency "rails", ">= 4", "< 6"

  gem.add_development_dependency "rspec-rails"
  gem.add_development_dependency "rspec-its"
  gem.add_development_dependency "sqlite3"
end
