defmodule Clamex.Scanner.Mock do
  @moduledoc """
  Mock scanner.

  Provides responses without actually running any external scanner
  behind the scenes.
  """

  @behaviour Clamex.Scanner

  @doc """
  Return mocked response depending on value of `path` argument.

  It matches `path` against one of the defined patterns to decide
  which response to return.

  ## Defined patterns

  * `"virus*"`
  * `"missing*"`
  * `"no-daemon*"`
  * `"no-scanner*"`

  Because of wildcard-matching, paths with any extension can be matched,
  e.g. `"virus.pdf"` or `"virus/image.png"`, depending on the test scenario.

  ## Examples

  Pretend that file is infected

      iex> Clamex.Scanner.Mock.scan("virus.txt")
      {:error, :virus_found}

  Pretend that file does not exist

      iex> Clamex.Scanner.Mock.scan("missing.png")
      {:error, :cannot_access_file}

  Pretend that clamd daemon is not running in background

      iex> Clamex.Scanner.Mock.scan("no-daemon.pdf")
      {:error, :cannot_connect_to_clamd}

  Pretend that scanner's executable is not available

      iex> Clamex.Scanner.Mock.scan("no-scanner.csv")
      {:error, :scanner_not_available}

  Pretend that file is safe

      iex> Clamex.Scanner.Mock.scan("anything/else.doc")
      :ok

  """
  @spec scan(path :: Path.t()) ::
              :ok | {:error, atom()} | {:error, String.t()}
  def scan(path) do
    cond do
      path =~ ~r{^virus} -> {:error, :virus_found}
      path =~ ~r{^missing} -> {:error, :cannot_access_file}
      path =~ ~r{^no-daemon} -> {:error, :cannot_connect_to_clamd}
      path =~ ~r{^no-scanner} -> {:error, :scanner_not_available}
      true -> :ok
    end
  end
end
