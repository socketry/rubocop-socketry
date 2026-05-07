# Releases

## v0.10.0

  - Fixed `Layout/BlockDelimiterSpacing` to correctly treat a block as a statement (requiring space before `{`) when it is the sole body of a multi-line outer block or method/class/module definition. Previously, the absence of a `:begin` wrapper in the AST caused such blocks (e.g. `Async {foo}` or `let(:bar) {baz}` inside a `describe`/`context` block) to be misclassified as expression-context and have their space incorrectly removed.
  - Single-line inline outer blocks (e.g. `foo {bar{baz}}`) continue to use compact style with no space before the inner brace.

## v0.9.0

  - Fixed `Layout/ConsistentBlankLineIndentation` to correctly handle files containing multiple blocks.
  - Expanded `Layout/BlockDelimiterSpacing` test coverage to include method chaining scenarios.

## v0.8.0

  - Fixed `Layout/BlockDelimiterSpacing` to correctly distinguish between statement and expression contexts for blocks inside `do...end` blocks.

## v0.7.0

  - Fixed `Layout/BlockDelimiterSpacing` to correctly handle blocks inside `do...end` blocks (statements should have space before braces).

## v0.6.1

  - Refined `Style/GlobalExceptionVariables` to allow global exception variables in safe contexts:
      - Inside rescue blocks (well-defined scope).
      - In rescue modifiers (`expression rescue $!`).
      - In method parameter defaults (`def foo(error = $!)`).
  - Added specific warning for using global exception variables in ensure blocks (extremely unsafe).

## v0.6.0

  - Extended `Layout/BlockDelimiterSpacing` to handle lambda and proc constructs (`->`, `lambda`, `proc`, `Proc.new`).

## v0.5.0

  - Added `Style/GlobalExceptionVariables` cop to warn against using global exception variables (`$!`, `$@`, `$ERROR_INFO`, `$ERROR_POSITION`).

## v0.4.0

  - Added `Layout/BlockDelimiterSpacing` cop to enforce consistent spacing before block delimiters.

## v0.1.0

  - Initial implementation of `Layout/ConsistentBlankLineIndentation`.
