# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kumogata/template/version'

Gem::Specification.new do |spec|
  spec.name          = 'kumogata-template'
  spec.version       = KUMOGATA_TEMPLATE_VERSION
  spec.authors       = ['Naoya Nakazawa']
  spec.email         = ['me@n0ts.org']
  spec.summary       = %q{Template for Kumogata.}
  spec.description   = %q{Template for Kumogata. Kumogata is a tool for AWS CloudFormation. It can define a template in Ruby DSL.}
  spec.homepage      = 'https://github.com/n0ts/kumogata-template'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk', '~> 2.3'
  spec.add_dependency 'kumogata2-plugin-ruby', '~> 0.1'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'minitest', '~> 5.11'
end
