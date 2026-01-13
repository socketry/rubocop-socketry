# RuboCop::Socketry

RuboCop rules for Socketry projects.

[![Development Status](https://github.com/socketry/rubocop-socketry/workflows/Test/badge.svg)](https://github.com/socketry/rubocop-socketry/actions?workflow=Test)

## Installation

    bundle add rubocop-socketry

## Usage

Please see the [project documentation](https://socketry.github.io/rubocop-socketry/) for more details.

## Available Cops

### Layout/ConsistentBlankLineIndentation

Ensures that blank lines have the same indentation as the previous non-blank line.

``` yaml
Layout/ConsistentBlankLineIndentation:
  Enabled: true
```

## Releases

Please see the [project releases](https://socketry.github.io/rubocop-socketry/releases/index) for all releases.

### v0.8.0

  - Fixed `Layout/BlockDelimiterSpacing` to correctly distinguish between statement and expression contexts for blocks inside `do...end` blocks.

### v0.7.0

  - Fixed `Layout/BlockDelimiterSpacing` to correctly handle blocks inside `do...end` blocks (statements should have space before braces).

### v0.6.1

  - Refined `Style/GlobalExceptionVariables` to allow global exception variables in safe contexts:
      - Inside rescue blocks (well-defined scope).
      - In rescue modifiers (`expression rescue $!`).
      - In method parameter defaults (`def foo(error = $!)`).
  - Added specific warning for using global exception variables in ensure blocks (extremely unsafe).

### v0.6.0

  - Extended `Layout/BlockDelimiterSpacing` to handle lambda and proc constructs (`->`, `lambda`, `proc`, `Proc.new`).

### v0.5.0

  - Added `Style/GlobalExceptionVariables` cop to warn against using global exception variables (`$!`, `$@`, `$ERROR_INFO`, `$ERROR_POSITION`).

### v0.4.0

  - Added `Layout/BlockDelimiterSpacing` cop to enforce consistent spacing before block delimiters.

### v0.1.0

  - Initial implementation of `Layout/ConsistentBlankLineIndentation`.

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

In order to protect users of this project, we require all contributors to comply with the [Developer Certificate of Origin](https://developercertificate.org/). This ensures that all contributions are properly licensed and attributed.

### Community Guidelines

This project is best served by a collaborative and respectful environment. Treat each other professionally, respect differing viewpoints, and engage constructively. Harassment, discrimination, or harmful behavior is not tolerated. Communicate clearly, listen actively, and support one another. If any issues arise, please inform the project maintainers.
