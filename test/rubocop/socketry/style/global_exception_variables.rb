# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "rubocop/socketry/style/global_exception_variables"

describe RuboCop::Socketry::Style::GlobalExceptionVariables do
	let(:config) {RuboCop::Config.new}
	let(:cop) {subject.new(config)}
	
	# Test $! variable in rescue block (allowed - well-defined scope)
	with "code using $! in rescue block" do
		let(:source) do
			<<~RUBY
				begin
					risky_operation
				rescue
					puts $!.message
				end
			RUBY
		end
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Test $@ variable in rescue block (allowed - well-defined scope)
	with "code using $@ in rescue block" do
		let(:source) do
			<<~RUBY
				begin
					risky_operation
				rescue
					puts $@.first
				end
			RUBY
		end
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Test $! in ensure block (extremely unsafe - should be flagged)
	with "code using $! in ensure block" do
		let(:source) do
			<<~RUBY
				begin
					risky_operation
				ensure
					log($!.message) if $!
				end
			RUBY
		end
		
		it "registers offenses with unsafe message" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.size).to be == 2
			expect(offenses.first.message).to be(:include?, "extremely unsafe")
		end
	end
	
	# Test $! in rescue modifier (allowed)
	with "code using $! in rescue modifier" do
		let(:source) do
			<<~RUBY
				result = risky_operation rescue $!
			RUBY
		end
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Test $! in parameter defaults (allowed - explicitly opting in)
	with "code using $! in parameter defaults" do
		let(:source) do
			<<~RUBY
				def foo(error = $!)
					puts error
				end
				
				def bar(error: $!)
					puts error
				end
			RUBY
		end
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Test proper exception handling (should not register offense)
	with "code using explicit exception variable" do
		let(:source) do
			<<~RUBY
				begin
					risky_operation
				rescue => error
					puts error.message
					puts error.backtrace.first
				end
			RUBY
		end
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Test with StandardError captured explicitly
	with "code using named exception variable" do
		let(:source) do
			<<~RUBY
				begin
					risky_operation
				rescue StandardError => e
					puts e.message
					puts e.backtrace.first
				end
			RUBY
		end
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Test multiple uses in same rescue block (allowed - well-defined scope)
	with "code using multiple global exception variables in rescue block" do
		let(:source) do
			<<~RUBY
				begin
					risky_operation
				rescue
					puts $!.message
					puts $@.join("\\n")
				end
			RUBY
		end
		
		it "does not register offenses" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
	
	# Test usage outside rescue block (still should be flagged)
	with "code using $! outside rescue block" do
		let(:source) do
			<<~RUBY
				def log_last_error
					puts $!.message if $!
				end
			RUBY
		end
		
		it "registers offenses" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.size).to be == 2
		end
	end
	
	# Test that other global variables are not flagged
	with "code using other global variables" do
		let(:source) do
			<<~RUBY
				puts $stdout
				puts $stderr
				puts $LOAD_PATH
			RUBY
		end
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses).to be(:empty?)
		end
	end
end

