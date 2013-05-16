unless defined? Tastevin::VERSION
  $LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

  require 'tastevin/version'
end

Gem::Specification.new do |s|
  s.name        = "tastevin"
  s.version     = Tastevin::VERSION
  s.summary     = "Configure and monitor agents from the command line"
  s.description = "Tastevin is a command line utility for configuring and monitoring agents."
  s.homepage    = "http://github.com/valotrading/tastevin"
  s.authors     = [ "Pekka Enberg", "Jussi Virtanen" ]
  s.email       = "engineering@valotrading.com"
  s.license     = "Apache License, Version 2.0"

  s.files = Dir[ 'README.md', 'bin/*', 'lib/**/*.rb' ]

  s.add_dependency 'highline', '~> 1.6'
  s.add_dependency 'inifile',  '~> 2.0'
  s.add_dependency 'rainbow',  '~> 1.1'
  s.add_dependency 'thor',     '~> 0.18'
  s.add_dependency 'wine',     '~> 0.1'

  s.add_development_dependency 'aruba',    '~> 0.5'
  s.add_development_dependency 'cucumber', '~> 1.3'
  s.add_development_dependency 'rake',     '~> 10.0'

  s.executables << 'tastevin'
end
