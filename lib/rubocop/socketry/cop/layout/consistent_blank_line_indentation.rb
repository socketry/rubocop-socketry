# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "rubocop"

module RuboCop
	module Cop
		module Layout
			# This cop requires that blank lines have the same indentation as the previous non-blank line.
			class ConsistentBlankLineIndentation < RuboCop::Cop::Base
				extend RuboCop::Cop::AutoCorrector
				
				MSG = "Blank lines must have the same indentation as the previous non-blank line."
				
				def on_new_investigation
					source_buffer = processed_source.buffer
					previous_indent = ""
					processed_source.lines.each_with_index do |line, index|
						if line.strip.empty?
							current_indent = line
							unless current_indent == previous_indent
								add_offense(
									source_range(source_buffer, index + 1, 0, line.length),
									message: MSG
								) do |corrector|
									corrector.replace(
										source_range(source_buffer, index + 1, 0, line.length),
										previous_indent
									)
								end
							end
						else
							previous_indent = line[/^\s*/]
						end
					end
				end
				
				private
				
				def source_range(buffer, line, column, length)
					Parser::Source::Range.new(buffer, buffer.line_range(line).begin_pos + column, buffer.line_range(line).begin_pos + column + length)
				end
			end
		end
	end
end 
