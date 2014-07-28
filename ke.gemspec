lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ke/version'

Gem::Specification.new do |spec|
  spec.name          = "ke"
  spec.version       = Ke::VERSION
  spec.authors       = ["Mark Dodwell"]
  spec.email         = ["mark@madeofcode.com"]
  spec.description   = "Measure progress of Ruby code."
  spec.summary       = "Measure progress of Ruby code."
  spec.homepage      = "https://github.com/mkdynamic/ke"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
