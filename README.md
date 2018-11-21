# Clamex

[![CircleCI](https://circleci.com/gh/szajbus/clamex/tree/master.svg?style=svg)](https://circleci.com/gh/szajbus/clamex/tree/master)

Clamex is a thin, error-friendly and testable wrapper for [ClamAV](https://www.clamav.net) written in elixir.

## Installation

The package can be installed by adding `clamex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:clamex, "~> 0.1.0"}
  ]
end
```

## Requirements

ClamAV is not included in this package and must be installed separately. Please consult [ClamAV's official documentation](https://www.clamav.net/documents/installing-clamav) on how to install it on your system.

## Configuration

It is recommended to have the ClamAV daemon (`clamd`) running in background and use `clamdscan` as a scanner, instead of `clamscan` which takes few seconds to initialize.

The following is the package's default configuration.

```elixir
config :clamex, scanner: Clamex.Scanner.Clamdscan
```

Alternatively, `Clamex.Scanner.Clamscan` or `Clamex.Scanner.Mock` (in tests, see below) can be used.

## Usage

Check if file is infected:

```elixir
iex> Clamex.virus?("test/files/virus.txt")
true

iex> Clamex.virus?("test/files/safe.txt")
false
```

Check if file is safe:

```elixir
iex> Clamex.safe?("test/files/virus.txt")
false

iex> Clamex.safe?("test/files/safe.txt")
true
```

Note that if the scanner encounters any errors, both `virus?` and `safe?` functions will quietly ignore them and return `false`. If you need to handle errors explicitly use the `scan` function directly.

Perform the file scan:

```elixir
iex> Clamex.scan("test/files/virus.txt")
{:error, :virus_found}

iex> Clamex.scan("test/files/safe.txt")
:ok
```

Please check the documentation for other error reasons that may be returned by `scan`.

## Documentation

Full documentation can be found at [https://hexdocs.pm/clamex](https://hexdocs.pm/clamex).

## Testing

You don't have to set ClamAV up in your test environment to test your application's behaviour with regard to file-scanning. You can simulate different scenarios: safe file, infected file, scanner not available, etc. using provided `Clamex.Scanner.Mock`.

Configure your test environment in `config/test.exs`:

```elixir
config :clamex, scanner: Clamex.Scanner.Mock
```

Please check the [`Clamex.Scanner.Mock` documentation](https://hexdocs.pm/clamex/Clamex.Scanner.Mock.html#content) for example usage.

## State of the library

`Clamex` is still experimental software.

Since it uses third-party scanners by calling external programs behind the scenes, things may go wrong. One of the design goals is to wrap this process in fault-tolerant way, so that the applications using `Clamex` are not susceptible to unpredicted error scenarios.

The most important aspect of the above is error-handling which is based on interpreting exit codes and parsing scanner's output.

There may still be error messages returned by `cladmscan` or `clamscan` that are currently not covered by `Clamex`. If you encounter such situations, feel free to report an issue or send a pull request.

## License

Copyright 2018 Michał Szajbe

Licensed under the MIT license. For more information see the [LICENSE.txt](LICENSE.txt) file.
