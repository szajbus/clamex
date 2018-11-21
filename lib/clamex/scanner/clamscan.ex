defmodule Clamex.Scanner.Clamscan do
  @moduledoc """
  Scanner implementation for `clamscan` command-line utility.
  """

  @behaviour Clamex.Scanner

  @doc """
  Perform file scan using `clamscan` command-line utility.

  ## Examples

      iex> Clamex.Scanner.Clamscan.scan("test/files/virus.txt")
      {:error, :virus_found}

      iex> Clamex.Scanner.Clamscan.scan("test/files/safe.txt")
      :ok

  ## Error reasons

  * `:virus_found` - file is infected
  * `:cannot_access_file` - file specified as `path` cannot be accessed
  * `:scanner_not_available` - scanner is not available at `executable_path`
  * any other error reported by the scanner will be returned as is (as String)

  """
  @callback scan(path :: Path.t()) ::
              :ok | {:error, atom()} | {:error, String.t()}
  def scan(path) do
    try do
      {output, exit_code} =
        System.cmd(
          "clamscan",
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
