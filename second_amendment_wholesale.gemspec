lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "second_amendment_wholesale/version"

Gem::Specification.new do |spec|
  spec.name          = "second_amendment_wholesale"
  spec.version       = SecondAmendmentWholesale::VERSION
  spec.authors       = ["Kevin Brown"]
  spec.email         = ["brownkm531@gmail.com"]

  spec.summary       = %q{Ruby library for 2nd Amendment Wholesale's API.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "activesupport", "~> 5"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.3"
end
