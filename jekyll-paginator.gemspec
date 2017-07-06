# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-paginator/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-paginator"
  spec.version       = Jekyll::Paginator::VERSION
  spec.authors       = ["Shiva Bhusal"]
  spec.email         = ["hotline.shiva@gmail.com"]
  spec.summary       = %q{Easy to use Pagination Generator for Jekyll with multiple pages support. }
  spec.homepage      = "https://shivabhusal.github.io/jekyll-paginator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "jekyll", ">= 2.0", "< 3.0"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
