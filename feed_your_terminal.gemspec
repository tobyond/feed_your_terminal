require_relative 'lib/feed_your_terminal/version'

Gem::Specification.new do |spec|
  spec.name          = "feed_your_terminal"
  spec.version       = FeedYourTerminal::VERSION
  spec.authors       = ["Toby"]
  spec.email         = ["toby@example.com"]

  spec.summary       = %q{RSS feed in your terminal}
  spec.description   = %q{RSS feed in your terminal}
  spec.homepage      = "https://github.com/tobyond"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tobyond"
  spec.metadata["changelog_uri"] = "https://github.com/tobyond"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
