lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'switcher/version'

Gem::Specification.new do |spec|
  spec.name          = "switcher"
  spec.version       = Switcher::VERSION
  spec.authors       = ["Chengqing Su"]
  spec.email         = ["suchengqing1995@gmail.com"]

  spec.summary       = "This is a tool to help you switch env, eg. aws account, k8s context"
  spec.description   = "This is a tool to help you switch env, eg. aws account, k8s context"
  spec.homepage      = "https://github.com/chengqing-su/switcher"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/chengqing-su/switcher.git"
  spec.metadata["changelog_uri"] = "https://github.com/chengqing-su/switcher"

  spec.add_dependency 'clamp', '~> 1.3.2'
  spec.add_dependency 'tty-config', '~> 0.4.0'
  spec.add_dependency 'tty-editor', '~> 0.6.0'
  spec.add_dependency 'tty-pager',  '~> 0.14'
  spec.add_dependency 'tty-prompt', '~> 0.22'
  spec.add_dependency 'tty-screen', '~> 0.8.1'
  spec.add_dependency 'tty-which',  '~> 0.4'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/switcher/extconf.rb"]
end
