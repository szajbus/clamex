defmodule Clamex do
  @moduledoc """
  Clamex is a thin wrapper for ClamAV.
  """

  @doc """
  Perform file scan

  ## Examples

      iex> Clamex.scan("test/files/virus.txt")
      {:error, :virus_found}

      iex> Clamex.scan("test/files/safe.txt")
      :ok

  ## Error reasons

  * `:virus_found` - file is infected
  * `:cannot_access_file` - file specified as `path` cannot be accessed
  * `:scanner_not_available` - scanner is not available at `executable_path`
  * `:cannot_connect_to_clamd` - ClamAV daemon is not running in background
  * any other error reported by the scanner will be returned as is (as String)

  """
  @spec scan(Path.t()) :: :ok | {:error, atom()} | {:error, String.t()}
  def scan(path) do
    with true <- scanner_available?(),
         :ok <- do_scan(path) do
      :ok
    else
      error -> error
    end
  end

  @doc """
  Check if file is infected

  ## Examples

      iex> Clamex.virus?("test/files/virus.txt")
      true

      iex> Clamex.virus?("test/files/safe.txt")
      false

  """
  @spec virus?(Path.t()) :: boolean
  def virus?(path) do
    case scan(path) do
      {:error, :virus_found} -> true
      _ -> false
    end
  end

  @doc """
  Check if file is safe

  ## Examples

      iex> Clamex.safe?("test/files/virus.txt")
      false

      iex> Clamex.safe?("test/files/safe.txt")
      true

  """
  @spec safe?(Path.t()) :: boolean
  def safe?(path) do
    case scan(path) do
      :ok -> true
      _ -> false
    end
  end

  defp scanner_available?() do
    try do
      {_output, exit_code} =
        System.cmd(
          executable_path(),
          ["--version", "--quiet", "--stdout"]
        )

      case exit_code do
        0 -> true
        _ -> {:error, :scanner_not_available}
      end
    rescue
      _ -> {:error, :scanner_not_available}
    end
  end

  defp do_scan(path) do
    {output, exit_code} =
      System.cmd(
        executable_path(),
        ["--no-summary", "--quiet", "--stdout", path]
      )

    case exit_code do
      0 -> :ok
      1 -> {:error, :virus_found}
      _ -> {:error, parse_error(output)}
    end
  end

  defp parse_error("ERROR: Can't access file" <> _), do: :cannot_access_file
  defp parse_error("ERROR: Could not connect to clamd" <> _), do: :cannot_connect_to_clamd
  defp parse_error("ERROR: " <> message), do: parse_error(message)
  defp parse_error(message), do: message

  defp executable_path, do: Application.get_env(:clamex, :executable_path, "clamdscan")
end
