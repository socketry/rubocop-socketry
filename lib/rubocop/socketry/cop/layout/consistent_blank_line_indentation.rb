# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "rubocop"

module RuboCop
	module Cop
		module Layout
			# This cop requires that blank lines have the correct indentation based on AST structure.
			class ConsistentBlankLineIndentation < RuboCop::Cop::Base
				extend RuboCop::Cop::AutoCorrector
				include Alignment
				include RangeHelp
				
				MESSAGE = "Blank lines must have the correct indentation."
				
				def configured_indentation_width
					cop_config["IndentationWidth"] || config.for_cop("Layout/IndentationWidth")["Width"] || 1
				end
				
				def configured_indentation_style
					cop_config["IndentationStyle"] || config.for_cop("Layout/IndentationStyle")["Style"] || "tab"
				end
				
				def indentation(width)
					case configured_indentation_style
					when "tab"
						"\t" * (width * configured_indentation_width)
					when "space"
						" " * (width * configured_indentation_width)
					end
				end
				
				def on_new_investigation
					indentation_deltas = build_indentation_deltas
					current_level = 0
					
					processed_source.lines.each_with_index do |line, index|
						line_number = index + 1
						
						# Blank line:
						if line.strip.empty?
							expected_indentation = indentation(current_level)
							if line != expected_indentation
								add_offense(
									source_range(processed_source.buffer, line_number, 0, line.length),
									message: MESSAGE
								) do |corrector|
									corrector.replace(
										source_range(processed_source.buffer, line_number, 0, line.length),
										expected_indentation
									)
								end
							end
						end
						
						delta = indentation_deltas[line_number] || 0
						current_level += delta
					end
				end
				
				private
				
				# Build a hash of line_number => delta (+1 for indent, -1 for dedent)
				def build_indentation_deltas
					deltas = Hash.new(0)
					walk_ast_for_indentation(processed_source.ast, deltas)
					deltas
				end
				
				def walk_ast_for_indentation(node, deltas)
					return unless node.is_a?(Parser::AST::Node)
					
					case node.type
					when :block, :hash, :array, :class, :module, :sclass, :def, :defs, :if, :case, :while, :until, :for, :kwbegin
						if location = node.location
							deltas[location.line] += 1
							deltas[location.last_line] -= 1
						end
					end
					
					node.children.each do |child|
						walk_ast_for_indentation(child, deltas)
					end
				end
				
				def source_range(buffer, line, column, length)
					Parser::Source::Range.new(buffer, buffer.line_range(line).begin_pos + column, buffer.line_range(line).begin_pos + column + length)
				end
			end
		end
	end
end 
