# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "rubocop"

module RuboCop
	module Socketry
		module Style
			# A RuboCop cop that warns against using global exception variables in unsafe contexts.
			# 
			# This cop discourages the use of:
			# - `$!` (last exception)
			# - `$@` (backtrace of last exception)
			# - `$ERROR_INFO` (English name for `$!`)
			# - `$ERROR_POSITION` (English name for `$@`)
			# 
			# These global variables are implicit and can make code harder to understand.
			# 
			# However, this cop allows their use in safe contexts where the scope is well-defined:
			# - Inside rescue blocks (well-defined scope)
			# - In rescue modifiers (`expression rescue $!`)
			# - In method parameter defaults (`def foo(error = $!)`, `def bar(error: $!)`)
			# 
			# This cop specifically flags their use in unsafe contexts:
			# - Inside ensure blocks (extremely unsafe - exception state is unpredictable)
			# - Outside of exception handling contexts
			# 
			# @example
			#   # bad - unsafe in ensure block
			#   begin
			#     risky_operation
			#   ensure
			#     log($!.message) if $!  # unsafe!
			#   end
			# 
			#   # bad - outside exception handling
			#   def process
			#     puts $!.message
			#   end
			# 
			#   # good - explicit exception handling
			#   begin
			#     risky_operation
			#   rescue => error
			#     puts error.message
			#   end
			# 
			#   # allowed - inside rescue block (well-defined scope)
			#   begin
			#     risky_operation
			#   rescue
			#     puts $!.message
			#   end
			# 
			#   # allowed - rescue modifier
			#   result = risky_operation rescue $!
			# 
			#   # allowed - parameter defaults
			#   def foo(error = $!)
			#   def bar(error: $!)
			class GlobalExceptionVariables < RuboCop::Cop::Base
				MSG = "Avoid using global exception variable `%<variable>s` in %<context>s. Use explicit exception handling with `rescue => error` instead."
				ENSURE_MSG = "Using global exception variable `%<variable>s` in an ensure block is extremely unsafe."
				
				EXCEPTION_VARIABLES = %i[$! $@ $ERROR_INFO $ERROR_POSITION].freeze
				
				def on_gvar(node)
					variable_name = node.children.first
					
					return unless EXCEPTION_VARIABLES.include?(variable_name)
					
					# Allow in parameter defaults (explicitly opting in)
					return if in_parameter_default?(node)
					
					# Allow in rescue modifier (well-defined scope)
					return if in_rescue_modifier?(node)
					
					# Allow in rescue block (well-defined scope)
					return if in_rescue_block?(node)
					
					# Flag if in ensure block (extremely unsafe)
					if in_ensure_block?(node)
						add_offense(
							node,
							message: format(ENSURE_MSG, variable: variable_name)
						)
						return
					end
					
					# Flag in all other contexts
					add_offense(
						node,
						message: format(MSG, variable: variable_name, context: "this context")
					)
				end
				
				private
				
				def in_parameter_default?(node)
					node.each_ancestor(:args, :optarg, :kwoptarg).any?
				end
				
				def in_rescue_modifier?(node)
					node.each_ancestor(:rescue).any? do |ancestor|
						# A rescue modifier has no resbody children
						# e.g., `expression rescue $!` is a rescue node with 2 children: expression and handler
						# A regular rescue has resbody children
						!ancestor.children.any?{|child| child.is_a?(RuboCop::AST::Node) && child.type == :resbody}
					end
				end
				
				def in_rescue_block?(node)
					node.each_ancestor(:resbody).any?
				end
				
				def in_ensure_block?(node)
					node.each_ancestor(:ensure).any?
				end
			end
		end
	end
end

