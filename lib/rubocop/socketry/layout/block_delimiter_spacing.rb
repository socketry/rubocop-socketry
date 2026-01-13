# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "rubocop"

module RuboCop
	module Socketry
		module Layout
			# A RuboCop cop that enforces consistent spacing before block delimiters.
			# 
			# This cop enforces the following style:
			# - `foo {bar}` - space for top-level statements without parentheses.
			# - `x = foo{bar}` - no space when part of an expression (assignment, argument, etc).
			# - `foo(1, 2) {bar}` - space after closing paren for top-level statements.
			# - `array.each{|x| x*2}.reverse` - no space for method chains.
			# - `->(foo){foo}` - no space for lambdas (stabby lambda syntax).
			# - `lambda{foo}` - no space for lambda keyword.
			# - `proc{foo}` - no space for proc keyword.
			# - `Proc.new{foo}` - no space for `Proc.new`.
			class BlockDelimiterSpacing < RuboCop::Cop::Base
				extend Cop::AutoCorrector
				
				MSG_ADD_SPACE = "Add a space before the opening brace."
				MSG_REMOVE_SPACE = "Remove space before the opening brace for method chains."
				MSG_REMOVE_SPACE_LAMBDA = "Remove space before the opening brace for lambdas/procs."
				MSG_REMOVE_SPACE_EXPRESSION = "Remove space before the opening brace for expressions."
				
				def on_block(node)
					return unless node.braces?
					
					send_node = node.send_node
					
					# Priority 1: Check if it's a lambda or proc
					# Lambdas/procs should never have space before {
					if lambda_or_proc?(send_node)
						# ->(foo){foo} - no space (stabby lambda)
						# lambda{foo} - no space (lambda keyword)
						# proc{foo} - no space (proc keyword)
						# Proc.new{foo} - no space (Proc.new)
						check_no_space_for_lambda(node, send_node)
					# Priority 2: Check if it's part of a method chain
					# Method chains should never have space, even with parentheses
					elsif part_of_method_chain?(node)
						# array.each{|x| x*2}.reverse - no space
						# obj.method(1, 2){|x| x}.other - also no space
						check_no_space_before_brace(node, send_node)
					# Priority 3: Check if it's part of an expression (not top-level)
					# Blocks within expressions should have no space
					elsif part_of_expression?(node)
						# x = Async{server.run} - no space (part of assignment)
						# foo(bar{baz}) - no space (part of argument)
						check_no_space_for_expression(node, send_node)
					elsif has_parentheses?(send_node)
						# foo(1, 2) {bar} - space after ) for standalone methods
						check_space_after_parentheses(node, send_node)
					else
						# foo {bar} - space for standalone methods without parens
						check_space_before_brace(node, send_node)
					end
				end
				
				private
				
				# Check if the send node is a lambda or proc (any form)
				def lambda_or_proc?(send_node)
					return true if send_node.lambda? # stabby lambda: ->{}
					return true if send_node.method_name == :lambda # lambda keyword: lambda{}
					return true if send_node.method_name == :proc # proc keyword: proc{}
					
					# Check for Proc.new{}
					if send_node.method_name == :new && send_node.receiver&.const_type?
						# Check if the receiver is the Proc constant
						receiver = send_node.receiver
						return true if receiver.const_name == :Proc && receiver.children.first.nil?
					end
					
					false
				end
				
				# Check if the block is part of an expression (not a top-level statement)
				# Top-level statements are directly inside a :begin node (file/method body)
				# or inside do...end block bodies, and should have space.
				# Everything else (expressions, nested arguments, etc.) should not have space.
				def part_of_expression?(node)
					parent = node.parent
					return false unless parent
					
					# If parent is a :begin node (sequence of statements), this is top-level
					return false if parent.type == :begin
					
					# If parent is a :block node, check if it's a do...end block
					# do...end blocks contain statements (no space)
					# {...} blocks contain expressions (space required)
					if parent.type == :block
						# do...end blocks use keywords, {...} blocks use braces
						return false unless parent.braces?
					end
					
					# Check if we're in a :kwbegin node (begin...end block body)
					return false if parent.type == :kwbegin
					
					# Otherwise, it's part of an expression (assignment, argument, etc.)
					true
				end
				
				# Check that there's no space before the opening brace for lambdas
				def check_no_space_for_lambda(block_node, send_node)
					brace_begin = block_node.loc.begin
					
					# Find the position just before the brace
					char_before_pos = brace_begin.begin_pos - 1
					
					return if char_before_pos < 0
					
					char_before = processed_source.buffer.source[char_before_pos]
					
					# If there's no space before the brace, we're good
					return unless char_before == " "
					
					# Find the extent of whitespace before the brace
					start_pos = char_before_pos
					while start_pos > 0 && processed_source.buffer.source[start_pos - 1] =~ /\s/
						start_pos -= 1
					end
					
					space_range = Parser::Source::Range.new(
						processed_source.buffer,
						start_pos,
						brace_begin.begin_pos
					)
					
					add_offense(
						space_range,
						message: MSG_REMOVE_SPACE_LAMBDA
					) do |corrector|
						corrector.remove(space_range)
					end
				end
				
				# Check that there's no space before the opening brace for expressions
				def check_no_space_for_expression(block_node, send_node)
					brace_begin = block_node.loc.begin
					
					# Find the position just before the brace
					char_before_pos = brace_begin.begin_pos - 1
					
					return if char_before_pos < 0
					
					char_before = processed_source.buffer.source[char_before_pos]
					
					# If there's no space before the brace, we're good
					return unless char_before == " "
					
					# Find the extent of whitespace before the brace
					start_pos = char_before_pos
					while start_pos > 0 && processed_source.buffer.source[start_pos - 1] =~ /\s/
						start_pos -= 1
					end
					
					space_range = Parser::Source::Range.new(
						processed_source.buffer,
						start_pos,
						brace_begin.begin_pos
					)
					
					add_offense(
						space_range,
						message: MSG_REMOVE_SPACE_EXPRESSION
					) do |corrector|
						corrector.remove(space_range)
					end
				end
				
				# Check if the block is part of a method chain (e.g., foo{}.bar or foo.bar{}.baz)
				def part_of_method_chain?(block_node)
					send_node = block_node.send_node
					parent = block_node.parent
					
					# Check if there's a method call after the block (foo{}.bar)
					has_chained_method_after = parent&.send_type? && parent.receiver == block_node
					
					# Check if the block's receiver exists (foo.bar{} or array.map{})
					# Any method call with a receiver is part of a chain
					has_receiver_before = send_node.receiver
					
					has_chained_method_after || has_receiver_before
				end
				
				# Check if the method call has parentheses
				def has_parentheses?(send_node)
					send_node.parenthesized?
				end
				
				# Check that there's a space between closing paren and opening brace
				def check_space_after_parentheses(block_node, send_node)
					paren_end = send_node.loc.end
					brace_begin = block_node.loc.begin
					
					return unless paren_end && brace_begin
					
					# Get the source between ) and {
					space_range = Parser::Source::Range.new(
						processed_source.buffer,
						paren_end.end_pos,
						brace_begin.begin_pos
					)
					
					space_between = space_range.source
					
					# Should have exactly one space
					return if space_between == " "
					
					if space_between.empty?
						add_offense(
							brace_begin,
							message: MSG_ADD_SPACE
						) do |corrector|
							corrector.insert_before(brace_begin, " ")
						end
					elsif space_between.match?(/\A\s+\z/)
						# Multiple spaces or tabs - replace with single space
						add_offense(
							space_range,
							message: MSG_ADD_SPACE
						) do |corrector|
							corrector.replace(space_range, " ")
						end
					end
				end
				
				# Check that there's no space before the opening brace
				def check_no_space_before_brace(block_node, send_node)
					brace_begin = block_node.loc.begin
					
					# Find the position just before the brace
					char_before_pos = brace_begin.begin_pos - 1
					
					return if char_before_pos < 0
					
					char_before = processed_source.buffer.source[char_before_pos]
					
					# If there's a space before the brace, we need to remove it
					return unless char_before == " "
					
					# Don't remove space if it's after a closing paren (that case is handled separately)
					if send_node.loc.end && send_node.loc.end.end_pos == char_before_pos + 1
						return
					end
					
					# Find the extent of whitespace before the brace
					start_pos = char_before_pos
					while start_pos > 0 && processed_source.buffer.source[start_pos - 1] =~ /\s/
						start_pos -= 1
					end
					
					space_range = Parser::Source::Range.new(
						processed_source.buffer,
						start_pos,
						brace_begin.begin_pos
					)
					
					add_offense(
						space_range,
						message: MSG_REMOVE_SPACE
					) do |corrector|
						corrector.remove(space_range)
					end
				end
				
				# Check that there's a space before the opening brace (for standalone methods)
				def check_space_before_brace(block_node, send_node)
					brace_begin = block_node.loc.begin
					
					# Find the position just before the brace
					char_before_pos = brace_begin.begin_pos - 1
					
					return if char_before_pos < 0
					
					char_before = processed_source.buffer.source[char_before_pos]
					
					# If there's already a space, we're good
					return if char_before == " "
					
					# Otherwise, we need to add a space
					add_offense(
						brace_begin,
						message: MSG_ADD_SPACE
					) do |corrector|
						corrector.insert_before(brace_begin, " ")
					end
				end
			end
		end
	end
end
