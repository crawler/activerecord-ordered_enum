require_relative "lib/active_record/ordered_enum/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-ordered_enum"
  spec.version = Activerecord::OrderedEnum::VERSION
  spec.authors = ["Anton Topchii"]
  spec.email = ["player1@infinitevoid.net"]

  spec.summary = "This gem adds query methods to be used with ActiveRecord::Enum that allow you to treat it like an ordered state."
  spec.homepage = "https://github.com/crawler/activerecord-ordered_enum"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/crawler/activerecord-ordered_enum/issues",
    "changelog_uri" => "https://github.com/crawler/activerecord-ordered_enum/releases",
    "source_code_uri" => "https://github.com/crawler/activerecord-ordered_enum",
    "homepage_uri" => spec.homepage
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency(%q<activesupport>.freeze, [">= 5.2.0"])
  spec.add_dependency(%q<activerecord>.freeze, [">= 5.2.0"])
end
