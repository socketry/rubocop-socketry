# Releases

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
