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
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a block with incorrect indentation" do
		let(:source) {"foo do\n\n\tbar\nend\n"}
		
		it "registers an offense when blank line is not indented for block context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a block with parameters and incorrect indentation" do
		let(:source) {"foo do |bar|\n\n\tbaz\nend\n"}
		
		it "registers an offense when blank line is not indented for block with parameters" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in an if statement with incorrect indentation" do
		let(:source) {"if condition\n\n\tputs 'hello'\nend\n"}
		
		it "registers an offense when blank line is not indented for if context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a case statement with incorrect indentation" do
		let(:source) {"case value\nwhen 1\n\n\tputs 'one'\nwhen 2\n\tputs 'two'\nend\n"}
		
		it "registers an offense when blank line is not indented for case context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a class definition with incorrect indentation" do
		let(:source) {"class MyClass\n\n\tdef method\n\t\tputs 'hello'\n\tend\nend\n"}
		
		it "registers an offense when blank line is not indented for class context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a module definition with incorrect indentation" do
		let(:source) {"module MyModule\n\n\tdef method\n\t\tputs 'hello'\n\tend\nend\n"}
		
		it "registers an offense when blank line is not indented for module context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a begin block with incorrect indentation" do
		let(:source) {"begin\n\n\tputs 'hello'\nrescue => e\n\tputs e\nend\n"}
		
		it "registers an offense when blank line is not indented for begin context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a while loop with incorrect indentation" do
		let(:source) {"while condition\n\n\tputs 'hello'\nend\n"}
		
		it "registers an offense when blank line is not indented for while context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in an until loop with incorrect indentation" do
		let(:source) {"until condition\n\n\tputs 'hello'\nend\n"}
		
		it "registers an offense when blank line is not indented for until context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a for loop with incorrect indentation" do
		let(:source) {"for item in items\n\n\tputs item\nend\n"}
		
		it "registers an offense when blank line is not indented for for context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in a rescue block with incorrect indentation" do
		let(:source) {"begin\n\tputs 'hello'\nrescue => e\n\n\tputs e\nend\n"}
		
		it "registers an offense when blank line is not indented for rescue context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
	
	with "a blank line in an ensure block with incorrect indentation" do
		let(:source) {"begin\n\tputs 'hello'\nensure\n\n\tputs 'cleanup'\nend\n"}
		
		it "registers an offense when blank line is not indented for ensure context" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
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
			expect(offenses.length).to be == 0
		end
	end
end
