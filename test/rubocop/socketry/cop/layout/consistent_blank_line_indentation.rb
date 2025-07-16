# frozen_string_literal: true

require "rubocop/socketry/cop/layout/consistent_blank_line_indentation"

describe RuboCop::Cop::Layout::ConsistentBlankLineIndentation do
	let(:cop) {subject.new}
	
	with "a blank line with inconsistent indentation" do
		let(:source) {"def foo\n\tputs 'bar'\n\t\t\n\tputs 'baz'\nend\n"}
		
		it "registers an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 1
			expect(offenses.first.message).to be(:include?, RuboCop::Cop::Layout::ConsistentBlankLineIndentation::MSG)
		end
	end
	
	with "a blank line with consistent indentation" do
		let(:source) {"def foo\n\tputs 'bar'\n\t\n\tputs 'baz'\nend\n"}
		
		it "does not register an offense" do
			processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
			investigator = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
			report = investigator.investigate(processed_source)
			offenses = report.offenses
			expect(offenses.length).to be == 0
		end
	end
end 