lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'long_term_storage/version'

Gem::Specification.new do |spec|
  spec.name          = "long_term_storage"
  spec.version       = LongTermStorage::VERSION
  spec.authors       = ["Daniel Jurek"]
  spec.email         = ["daniel@octaviuslabs.com"]
  spec.description   = %q{Long Term Storage/Retrieval (currently abstracts S3)}
  spec.summary       = %q{Long Term Storage/Retrieval (currently abstracts S3)}
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'engtagger'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'

  # Runtime dependencies
  spec.add_runtime_dependency 'aws-sdk', '~> 2'
end
