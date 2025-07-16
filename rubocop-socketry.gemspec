# frozen_string_literal: true

require_relative "lib/rubocop/socketry/version"

Gem::Specification.new do |spec|
	spec.name = "rubocop-socketry"
	spec.version = RuboCop::Socketry::VERSION
	
	spec.summary = "Personal RuboCop rules for Socketry projects"
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ["release.cert"]
	spec.signing_key = File.expand_path("~/.gem/release.pem")
	
	spec.homepage = "https://github.com/socketry/rubocop-socketry"
	
	spec.metadata = {
		"default_lint_roller_plugin" => "RuboCop::Socketry::Plugin",
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
		"source_code_uri" => "https://github.com/socketry/rubocop-socketry.git",
	}
	
	spec.files = Dir["{lib}/**/*", "*.md", base: __dir__]
	
	spec.required_ruby_version = ">= 3.2"
	
	spec.add_dependency "lint_roller"
	spec.add_dependency "rubocop", ">= 1.72"
end
