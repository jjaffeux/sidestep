# -*- encoding: utf-8 -*-
VERSION = "2.0.0".freeze

Gem::Specification.new do |spec|
  spec.name          = "sidestep"
  spec.version       = VERSION
  spec.authors       = ["Joffrey Jaffeux"]
  spec.email         = ["j.jaffeux@gmail.com"]
  spec.description   = %q{Simple gem to load one specific controller on demand}
  spec.summary       = %q{Simple gem to load one specific controller on demand}
  spec.homepage      = ""
  spec.license       = ""

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
