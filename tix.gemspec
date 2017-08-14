# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tps/version'

Gem::Specification.new do |spec|
  spec.name          = 'tps'
  spec.version       = Tps::VERSION
  spec.authors       = ['Andrew Bigger']
  spec.email         = ['andrew.bigger@gmail.com']

  spec.summary       = 'Parse and search json on the command line'
  spec.homepage      = 'https://github.com/andrewbigger/tps'
  spec.license       = 'None'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'yajl-ruby', '~> 1.3.0'
  spec.add_dependency 'highline', '~> 1.7.8'
  spec.add_dependency 'pry', '0.10.4'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
