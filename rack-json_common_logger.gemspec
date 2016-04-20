# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rack-json_common_logger"
  spec.version       = '0.1.1'
  spec.authors       = ["Bishnu Subedi"]
  spec.email         = ["bisusubedi@gmail.com"]

  spec.summary       = %q{ A Rack commonlogger based json logger middleware }
  spec.description   = %q{ Monkey patching of rack commomlogger module to write rack logs in json format.}
  spec.homepage      = "https://github.com/bisusubedi/rack-json_common_logger"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   # spec.metadata['allowed_push_host'] = "https://gems.my-company.example"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack", "~> 1.6.4"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
