# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seo_report/version'

Gem::Specification.new do |spec|
  spec.name          = "seo_report"
  spec.version       = SeoReport::VERSION
  spec.authors       = ["Tim Reddehase"]
  spec.email         = ["robustus@rightsrestricted.com"]

  spec.summary       = %q{report seo relevant data for a given url}
  spec.description   = %q{Get a report with seo relevant data for a given URL, like redirects, canonical, robots, Soc. Med. data and so on.}
  spec.homepage      = "https://github.com/0robustus1/seo_report"
  spec.license       = "LGPL-3.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6", ">= 1.6.8"
  spec.add_dependency "json", "~> 2.0", ">= 2.0.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "pry", "~> 0.10"
end
