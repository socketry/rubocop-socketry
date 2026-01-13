# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025-2026, by Samuel Williams.

require "rubocop/socketry/layout/block_delimiter_spacing"

describe RuboCop::Socketry::Layout::BlockDelimiterSpacing do
	let(:config) {RuboCop::Config.new}
	let(:cop) {subject.new(config)}
	
	# Case 1: Method without parentheses - space before brace
	with "a block on a method without parentheses" do
		let(:source) {"foo {bar}"}
		
		it "does not register an offense when there's a space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a block on a method without parentheses but no space" do
		let(:source) {"foo{bar}"}
		
		it "registers an offense when there's no space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Add a space")
		end
	end
	
	# Case 2: Method with parentheses - space after closing paren
	with "a block on a method with parentheses and proper spacing" do
		let(:source) {"foo(1, 2, 3) {bar}"}
		
		it "does not register an offense when there's a space after paren" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a block on a method with parentheses but no space" do
		let(:source) {"foo(1, 2, 3){bar}"}
		
		it "registers an offense when there's no space after paren" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Add a space")
		end
	end
	
	with "a block on a method with empty parentheses" do
		let(:source) {"foo() {bar}"}
		
		it "does not register an offense with proper spacing" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Case 3: Method chains - no space before brace
	with "a block in a method chain" do
		let(:source) {"array.each{|x| x * 2}.reverse"}
		
		it "does not register an offense when there's no space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a block in a method chain with space" do
		let(:source) {"array.each {|x| x * 2}.reverse"}
		
		it "registers an offense when there's a space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	with "a block with chained methods after it" do
		let(:source) {"foo {bar}.baz.qux"}
		
		it "registers an offense for standalone method with space in a chain" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	with "a block with chained methods after it without space" do
		let(:source) {"foo{bar}.baz.qux"}
		
		it "does not register an offense for method chain style" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Edge cases
	with "a multi-line block without parentheses" do
		let(:source) {"foo {\n  bar\n  baz\n}"}
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a multi-line block with parentheses" do
		let(:source) {"foo(1, 2) {\n  bar\n  baz\n}"}
		
		it "does not register an offense with proper spacing" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a block with block parameters" do
		let(:source) {"foo {|x, y| x + y}"}
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "let(:x) pattern" do
		let(:source) {"let(:x) {foo}"}
		
		it "does not register an offense with space after paren" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "let(:x) pattern without space" do
		let(:source) {"let(:x){foo}"}
		
		it "registers an offense when space is missing after paren" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Add a space")
		end
	end
	
	with "nested blocks" do
		let(:source) {"foo {bar{baz}}"}
		
		it "does not register an offense for nested blocks without inner space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "chained blocks in method chain" do
		let(:source) {"array.map{|x| x * 2}.select{|x| x > 5}"}
		
		it "does not register an offense for multiple chained blocks" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "do...end blocks" do
		let(:source) {"foo do\n  bar\nend"}
		
		it "does not check do...end blocks" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "method with arguments and block in chain" do
		let(:source) {"obj.method(1, 2){|x| x}.other"}
		
		it "does not require space in method chain even with parentheses" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "method with arguments and block in chain with space" do
		let(:source) {"obj.method(1, 2) {|x| x}.other"}
		
		it "registers an offense when there's a space in method chain" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	# Lambda cases
	with "a lambda with arguments and no space" do
		let(:source) {"->(foo){foo}"}
		
		it "does not register an offense for lambda without space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a lambda with arguments and space" do
		let(:source) {"->(foo) {foo}"}
		
		it "registers an offense for lambda with space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	with "a lambda without arguments and no space" do
		let(:source) {"->{puts 'hello'}"}
		
		it "does not register an offense for lambda without space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a lambda without arguments and with space" do
		let(:source) {"-> {puts 'hello'}"}
		
		it "registers an offense for lambda with space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	# proc keyword cases
	with "proc keyword without space" do
		let(:source) {"proc{puts 'hello'}"}
		
		it "does not register an offense for proc without space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "proc keyword with space" do
		let(:source) {"proc {puts 'hello'}"}
		
		it "registers an offense for proc with space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	# Proc.new cases
	with "Proc.new without space" do
		let(:source) {"Proc.new{puts 'hello'}"}
		
		it "does not register an offense for Proc.new without space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "Proc.new with space" do
		let(:source) {"Proc.new {puts 'hello'}"}
		
		it "registers an offense for Proc.new with space" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	# Expression context cases (assignments, arguments, etc.)
	with "a block in an assignment without space" do
		let(:source) {"x = Async{server.run}"}
		
		it "does not register an offense for expression context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a block in an assignment with space" do
		let(:source) {"x = Async {server.run}"}
		
		it "registers an offense for space in expression context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	with "a block as a method argument without space" do
		let(:source) {"foo(bar{baz})"}
		
		it "does not register an offense for expression context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a block as a method argument with space" do
		let(:source) {"foo(bar {baz})"}
		
		it "registers an offense for space in expression context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	with "a block in a return statement without space" do
		let(:source) {"return foo{bar}"}
		
		it "does not register an offense for expression context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a block in a return statement with space" do
		let(:source) {"return foo {bar}"}
		
		it "registers an offense for space in expression context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
	
	# Nested blocks inside do...end blocks
	with "a braces block inside a do...end block" do
		let(:source) do
			<<~RUBY
				foo do
					bar {baz}
				end
			RUBY
		end
		
		it "does not register an offense for standalone method call inside do...end" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a braces block inside a do...end block without space" do
		let(:source) do
			<<~RUBY
				foo do
					bar{baz}
				end
			RUBY
		end
		
		it "registers an offense for missing space before brace" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Add a space")
		end
	end
	
	# Method chains inside do...end should still follow method chain rules
	with "a method chain with block inside do...end block" do
		let(:source) do
			<<~RUBY
				foo do
					obj.bar{baz}
				end
			RUBY
		end
		
		it "does not register an offense (method chain rules apply)" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a method chain with block and space inside do...end block" do
		let(:source) do
			<<~RUBY
				foo do
					obj.bar {baz}
				end
			RUBY
		end
		
		it "registers an offense for unwanted space in method chain" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, "Remove space")
		end
	end
end
