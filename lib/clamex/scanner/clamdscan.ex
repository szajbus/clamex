defmodule Clamex.Scanner.Clamdscan do
  @moduledoc """
  Wrapper for `clamdscan` command-line utility.
  """

  @behaviour Clamex.Scanner

  @doc """
  Perform file scan using `clamdscan` command-line utility.

  ## Examples

      iex> Clamex.Scanner.Clamdscan.scan("test/files/virus.txt")
      {:error, :virus_found}

      iex> Clamex.Scanner.Clamdscan.scan("test/files/safe.txt")
      :ok

  ## Error reasons

  * `:virus_found` - file is infected
  * `:cannot_access_file` - file specified as `path` cannot be accessed
  * `:scanner_not_available` - scanner is not available at `executable_path`
  * `:cannot_connect_to_clamd` - ClamAV daemon is not running in background
  * any other error reported by the scanner will be returned as is (as String)

  """
  @callback scan(path :: Path.t()) ::
              :ok | {:error, atom()} | {:error, String.t()}
  def scan(path) do
    try do
      {output, exit_code} =
        System.cmd(
          "clamdscan",
          ["--no-summary", path],
          stderr_to_stdout: true
        )

      case exit_code do
        0 -> :ok
        1 -> {:error, :virus_found}
        _ -> {:error, Clamex.Output.extract_error(output)}
      end
    rescue
      :enoent -> {:error, :scanner_not_available}
    end
  end
end
