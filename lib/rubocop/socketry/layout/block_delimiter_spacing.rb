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
			# - `foo {bar}` - space when method has no parentheses and is not chained
			# - `foo(1, 2) {bar}` - space after closing paren for standalone methods
			# - `array.each{|x| x*2}.reverse` - no space for method chains (even with parens)
			class BlockDelimiterSpacing < RuboCop::Cop::Base
				extend Cop::AutoCorrector
				
				MSG_ADD_SPACE = "Add a space before the opening brace."
				MSG_REMOVE_SPACE = "Remove space before the opening brace for method chains."
				
				def on_block(node)
					return unless node.braces?
					
					send_node = node.send_node
					
					# Priority: Check if it's part of a method chain first
					# Method chains should never have space, even with parentheses
					if part_of_method_chain?(node)
						# array.each{|x| x*2}.reverse - no space
						# obj.method(1, 2){|x| x}.other - also no space
						check_no_space_before_brace(node, send_node)
					elsif has_parentheses?(send_node)
						# foo(1, 2) {bar} - space after ) for standalone methods
						check_space_after_paren(node, send_node)
					else
						# foo {bar} - space for standalone methods without parens
						check_space_before_brace(node, send_node)
					end
				end
				
				private
				
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
				def check_space_after_paren(block_node, send_node)
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
