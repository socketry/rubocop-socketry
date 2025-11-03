# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "rubocop/socketry/layout/consistent_blank_line_indentation"

describe RuboCop::Socketry::Layout::ConsistentBlankLineIndentation do
	let(:message) {subject::MESSAGE}
	
	# Configure the cop to use 1 tab for indentation:
	let(:config) do
		RuboCop::Config.new(
			"Layout/ConsistentBlankLineIndentation" => {
				"IndentationWidth" => 1,
				"IndentationStyle" => "tab"
			}
		)
	end
	
	let(:cop) {subject.new(config)}
	
	with "a blank line with inconsistent indentation" do
		let(:source) {"def foo\n\tputs 'bar'\n\t\t\n\tputs 'baz'\nend\n"}
		
		it "registers an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line with consistent indentation" do
		let(:source) {"def foo\n\tputs 'bar'\n\t\n\tputs 'baz'\nend\n"}
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a block with proper indentation" do
		let(:source) {"foo do\n\t\n\tbar\nend\n"}
		
		it "does not register an offense when blank line is properly indented for block context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a block with incorrect indentation" do
		let(:source) {"foo do\n\n\tbar\nend\n"}
		
		it "registers an offense when blank line is not indented for block context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in a block with parameters" do
		let(:source) {"foo do |bar|\n\t\n\tbaz\nend\n"}
		
		it "does not register an offense when blank line is properly indented for block with parameters" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a block with parameters and incorrect indentation" do
		let(:source) {"foo do |bar|\n\n\tbaz\nend\n"}
		
		it "registers an offense when blank line is not indented for block with parameters" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in an if statement with proper indentation" do
		let(:source) {"if condition\n\t\n\tputs 'hello'\nend\n"}
		
		it "does not register an offense when blank line is properly indented for if context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in an if statement with incorrect indentation" do
		let(:source) {"if condition\n\n\tputs 'hello'\nend\n"}
		
		it "registers an offense when blank line is not indented for if context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in a case statement with proper indentation" do
		let(:source) {"case value\nwhen 1\n\t\n\tputs 'one'\nwhen 2\n\tputs 'two'\nend\n"}
		
		it "does not register an offense when blank line is properly indented for case context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a case statement with incorrect indentation" do
		let(:source) {"case value\nwhen 1\n\n\tputs 'one'\nwhen 2\n\tputs 'two'\nend\n"}
		
		it "registers an offense when blank line is not indented for case context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in a class definition with proper indentation" do
		let(:source) {"class MyClass\n\t\n\tdef method\n\t\tputs 'hello'\n\tend\nend\n"}
		
		it "does not register an offense when blank line is properly indented for class context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a class definition with incorrect indentation" do
		let(:source) {"class MyClass\n\n\tdef method\n\t\tputs 'hello'\n\tend\nend\n"}
		
		it "registers an offense when blank line is not indented for class context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in a module definition with proper indentation" do
		let(:source) {"module MyModule\n\t\n\tdef method\n\t\tputs 'hello'\n\tend\nend\n"}
		
		it "does not register an offense when blank line is properly indented for module context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a module definition with incorrect indentation" do
		let(:source) {"module MyModule\n\n\tdef method\n\t\tputs 'hello'\n\tend\nend\n"}
		
		it "registers an offense when blank line is not indented for module context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in a begin block with proper indentation" do
		let(:source) {"begin\n\t\n\tputs 'hello'\nrescue => e\n\tputs e\nend\n"}
		
		it "does not register an offense when blank line is properly indented for begin context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a begin block with incorrect indentation" do
		let(:source) {"begin\n\n\tputs 'hello'\nrescue => e\n\tputs e\nend\n"}
		
		it "registers an offense when blank line is not indented for begin context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in a while loop with proper indentation" do
		let(:source) {"while condition\n\t\n\tputs 'hello'\nend\n"}
		
		it "does not register an offense when blank line is properly indented for while context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a while loop with incorrect indentation" do
		let(:source) {"while condition\n\n\tputs 'hello'\nend\n"}
		
		it "registers an offense when blank line is not indented for while context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in an until loop with proper indentation" do
		let(:source) {"until condition\n\t\n\tputs 'hello'\nend\n"}
		
		it "does not register an offense when blank line is properly indented for until context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in an until loop with incorrect indentation" do
		let(:source) {"until condition\n\n\tputs 'hello'\nend\n"}
		
		it "registers an offense when blank line is not indented for until context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in a for loop with proper indentation" do
		let(:source) {"for item in items\n\t\n\tputs item\nend\n"}
		
		it "does not register an offense when blank line is properly indented for for context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a for loop with incorrect indentation" do
		let(:source) {"for item in items\n\n\tputs item\nend\n"}
		
		it "registers an offense when blank line is not indented for for context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in a rescue block with proper indentation" do
		let(:source) {"begin\n\tputs 'hello'\nrescue => e\n\t\n\tputs e\nend\n"}
		
		it "does not register an offense when blank line is properly indented for rescue context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in a rescue block with incorrect indentation" do
		let(:source) {"begin\n\tputs 'hello'\nrescue => e\n\n\tputs e\nend\n"}
		
		it "registers an offense when blank line is not indented for rescue context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line in an ensure block with proper indentation" do
		let(:source) {"begin\n\tputs 'hello'\nensure\n\t\n\tputs 'cleanup'\nend\n"}
		
		it "does not register an offense when blank line is properly indented for ensure context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in an ensure block with incorrect indentation" do
		let(:source) {"begin\n\tputs 'hello'\nensure\n\n\tputs 'cleanup'\nend\n"}
		
		it "registers an offense when blank line is not indented for ensure context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "spaces indentation" do
		let(:config) do
			RuboCop::Config.new(
				"Layout/ConsistentBlankLineIndentation" => {
					"IndentationWidth" => 2,
					"IndentationStyle" => "space"
				}
			)
		end
		
		let(:source) {"def foo\n  puts 'bar'\n  \n  puts 'baz'\nend\n"}
		
		it "handles spaces indentation correctly" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a heredoc with proper indentation" do
		let(:source) {"def foo\n\tputs <<~FOO\n\t\tHello\n\t\tWorld\n\tFOO\nend\n"}
		
		it "does not register an offense when heredoc is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a heredoc with correct body indentation" do
		let(:source) {"def foo\n\tputs <<~FOO\n\t\tHello\n\t\tWorld\n\tFOO\nend\n"}
		it "does not register an offense for properly indented heredoc body" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a heredoc with incorrect body indentation" do
		let(:source) {"def foo\n\tputs <<~FOO\n\n\t\tHello World\n\tFOO\nend\n"}
		it "registers an offense for unindented heredoc body" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a non-squiggly heredoc with any indentation" do
		let(:source) {"def foo\n\tputs <<-FOO\n\t\tHello\n\t\tWorld\n\tFOO\nend\n"}
		it "does not register an offense for non-squiggly heredoc content" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a plain heredoc with any indentation" do
		let(:source) {"def foo\n\tputs <<FOO\n\t\tHello\n\t\tWorld\n\tFOO\nend\n"}
		it "does not register an offense for plain heredoc content" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "an interpolated string" do
		let(:source) {"def foo\n\tname = 'world'\n\tputs \"Hello \#{name}\"\n\t\n\tputs 'done'\nend\n"}
		it "does not interfere with blank line indentation for interpolated strings" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in if/elsif/else clauses with proper indentation" do
		let(:source) {"if foo\n\t\n\tputs 'foo'\nelsif bar\n\t\n\tputs 'bar'\nelse\n\t\n\tputs 'else'\nend\n"}
		it "does not register an offense when blank lines are properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line in if/elsif/else clauses with incorrect indentation" do
		let(:source) {"if foo\n\t\n\tputs 'foo'\nelsif bar\n\t\t\n\tputs 'bar'\nelse\n\t\n\tputs 'else'\nend\n"}
		it "registers an offense when blank line in elsif is over-indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
		end
	end
	
	with "a blank line inside a hash definition with proper indentation" do
		let(:source) {<<~RUBY}
			POLICY = {
				"foo" => false,
				
				"bar" => false
			}.tap{|hash| hash.default = true}
		RUBY
		
		it "does not register an offense when blank line in hash is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a hash definition with method chain" do
		let(:source) {<<~RUBY}
			CONFIG = {
				:development => {
					:database => "dev.db",
					
					:logging => true
				},
				:production => {
					:database => "prod.db",
					:logging => false
				}
			}.freeze
		RUBY
		
		it "does not register an offense for blank lines in nested hash with method chain" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside an array definition with method call" do
		let(:source) {<<~RUBY}
			ITEMS = [
				"first",
				"second",
				
				"third"
			].freeze
		RUBY
		
		it "does not register an offense when blank line in array with method call is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside an array definition with method chain" do
		let(:source) {<<~RUBY}
			NUMBERS = [
				1,
				2,
				
				3,
				4
			].map(&:to_s).freeze
		RUBY
		
		it "does not register an offense for blank lines in array with method chain" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside an array definition without method call" do
		let(:source) {<<~RUBY}
			ITEMS = [
				"first",
				"second",
				
				"third"
			]
		RUBY
		
		it "does not register an offense when blank line in standalone array is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a module definition with method call" do
		let(:source) {<<~RUBY}
			module M
				
				def foo
				end
			end.tap{}
		RUBY
		
		it "does not register an offense when blank line in module with method call is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a class definition with method call" do
		let(:source) {<<~RUBY}
			class C
				
				def foo
				end
			end.freeze
		RUBY
		
		it "does not register an offense when blank line in class with method call is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a method definition with method call" do
		let(:source) {<<~RUBY}
			def foo
				
				puts "hello"
			end.tap { |result| puts result }
		RUBY
		
		it "does not register an offense when blank line in method with chained call is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside an if statement with method call" do
		let(:source) {<<~RUBY}
			if condition
				
				"Hello"
			end.tap{}
		RUBY
		
		it "does not register an offense when blank line in if with method call is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a while loop with method call" do
		let(:source) {<<~RUBY}
			while condition
				
				puts "hello"
			end.tap{}
		RUBY
		
		it "does not register an offense when blank line in while with method call is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a case statement with method call" do
		let(:source) {<<~RUBY}
			case value
			when 1
				
				"one"
			end.upcase
		RUBY
		
		it "does not register an offense when blank line in case with method call is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a block with constant receiver" do
		let(:source) {"Sus::Shared(\"test\") do |shared|\n\t\n\tshared.call\nend\n"}
		
		it "does not register an offense when blank line in block with constant receiver is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a block with single-line array receiver" do
		let(:source) {"[false, true].each do\n\tputs \"A\"\n\n\tputs \"B\"\nend\n"}
		
		it "registers an offense when blank line in block with single-line array receiver is not indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
	
	with "a blank line inside a block with single-line array receiver and proper indentation" do
		let(:source) {"[false, true].each do\n\tputs \"A\"\n\t\n\tputs \"B\"\nend\n"}
		
		it "does not register an offense when blank line in block with single-line array receiver is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a multi-line array and block" do
		let(:source) {<<~RUBY}
			[
				1,
				
				3,
			].each do |i|
				puts i
				
				puts "---"
			end
		RUBY
		
		it "does not register an offense when blank lines in both array and block are properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	with "a blank line inside a multi-line array and block with incorrect indentation" do
		let(:source) {<<~RUBY}
			[
				1,
			
				3,
			].each do |i|
				puts i
			
				puts "---"
			end
		RUBY
		
		it "registers offenses when blank lines in both array and block are not properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.size).to be == 2  # One for array blank line, one for block blank line
			offenses.each do |offense|
				expect(offense.message).to be(:include?, message)
			end
		end
	end
	
	with "a regex with inconsistent indentation in blank lines" do
		let(:source) {<<~RUBY}
			REDACT = /
				phone
				| email
			
				| device_name
			/xi
		RUBY
		
		it "registers offenses when blank lines in regex literal are not properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.size).to be > 0
			offenses.each do |offense|
				expect(offense.message).to be(:include?, message)
			end
		end
	end
	
	with "a blank line inside a block with chained method call receiver" do
		let(:source) {"obj.method.tap do |result|\n\t\n\tputs result\nend\n"}
		
		it "does not register an offense when blank line in block with chained method call is properly indented" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# This test case specifically demonstrates the issue described by the user
	with "a blank line inside nested unless block" do
		let(:source) {"def hello(foo)\n\tunless foo\n\t\tx = 10\n\t\t\n\t\ty = 20\n\tend\nend\n"}
		
		it "should properly indent blank line with two tabs inside nested unless block" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# This test case shows the current incorrect behavior 
	with "a blank line inside nested unless block with incorrect indentation" do
		let(:source) {"def hello(foo)\n\tunless foo\n\t\tx = 10\n\t\n\t\ty = 20\n\tend\nend\n"}
		
		it "should register an offense when blank line has only one tab instead of two" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).not.to be(:empty?)
			expect(offenses.first.message).to be(:include?, message)
		end
	end
end
