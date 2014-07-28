lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dt/version'

Gem::Specification.new do |spec|
  spec.name          = "dt"
  spec.version       = Dt::VERSION
  spec.authors       = ["Mark Dodwell"]
  spec.email         = ["mark@madeofcode.com"]
  spec.description   = "Measure progress of Ruby code."
  spec.summary       = "Measure progress of Ruby code."
  spec.homepage      = "https://github.com/mkdynamic/dt"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
