# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "rubocop"

module RuboCop
	module Socketry
		module Style
			# A RuboCop cop that warns against using global exception variables.
			# 
			# This cop discourages the use of:
			# - `$!` (last exception)
			# - `$@` (backtrace of last exception)
			# - `$ERROR_INFO` (English name for `$!`)
			# - `$ERROR_POSITION` (English name for `$@`)
			# 
			# These global variables are implicit and can make code harder to understand.
			# Instead, use explicit exception handling with rescue blocks and local variables.
			# 
			# @example
			#   # bad
			#   begin
			#     risky_operation
			#   rescue
			#     puts $!.message
			#     puts $@.first
			#   end
			# 
			#   # good
			#   begin
			#     risky_operation
			#   rescue => error
			#     puts error.message
			#     puts error.backtrace.first
			#   end
			class GlobalExceptionVariables < RuboCop::Cop::Base
				MSG = "Avoid using global exception variable `%<variable>s`. " \
				      "Use explicit exception handling with `rescue => error` instead."
				
				EXCEPTION_VARIABLES = %i[$! $@ $ERROR_INFO $ERROR_POSITION].freeze
				
				def on_gvar(node)
					variable_name = node.children.first
					
					return unless EXCEPTION_VARIABLES.include?(variable_name)
					
					add_offense(
						node,
						message: format(MSG, variable: variable_name)
					)
				end
			end
		end
	end
end

