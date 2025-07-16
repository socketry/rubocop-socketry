# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "lint_roller"
require_relative "version"

module RuboCop
	module Socketry
		class Plugin < LintRoller::Plugin
			def initialize(...)
				super
				@version = RuboCop::Socketry::VERSION
			end
			
			def about
				LintRoller::About.new(
					name: "rubocop-socketry",
					version: @version,
					homepage: "https://github.com/socketry/rubocop-socketry",
					description: "Personal RuboCop rules for Socketry projects."
				)
			end
			
			def rules(context)
				LintRoller::Rules.new(
					type: :path,
					config_format: :rubocop,
					value: Pathname.new(__dir__).join("../../../config/default.yml")
				)
			end
		end
	end
end 
