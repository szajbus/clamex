# Clamex

Clamex is a thin, error-friendly wrapper for [ClamAV](https://www.clamav.net) written in elixir.

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
config :clamex, executable_path: "clamdscan"
```

If the `clamdscan` is not available in `$PATH` pull path to it can be specified as `executable_path`.

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

Note that if there scanner encounters any errors, both `virus?` and `safe?` functions will quietly ignore them and return `false`. If you need to handle errors explicitly use the `scan` function directly.

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

## License

Copyright 2018 Michał Szajbe

Licensed under the MIT license. For more information see the [LICENSE.txt](LICENSE.txt) file.
