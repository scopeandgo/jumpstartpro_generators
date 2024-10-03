# frozen_string_literal: true

require_relative "lib/jumpstartpro_generators/version"

Gem::Specification.new do |spec|
  spec.name = "jumpstartpro_generators"
  spec.version = JumpstartproGenerators::VERSION
  spec.authors = ["Dr Nic Williams"]
  spec.email = ["drnicwilliams@gmail.com"]

  spec.summary = "Generators for Jumpstart Pro projects."
  spec.description = "A collection of generators and configurations for Jumpstart Pro projects, including initial gems, config, and files." # Updated description
  spec.homepage = "https://github.com/scopeandgo/jumpstartpro_generators"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/scopeandgo/jumpstartpro_generators"
  spec.metadata["changelog_uri"] = "https://github.com/scopeandgo/jumpstartpro_generators/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rails"
end
