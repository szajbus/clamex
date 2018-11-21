defmodule Clamex do
  @moduledoc """
  Clamex is a thin wrapper for ClamAV.
  """

  @scanner Application.get_env(:clamex, :scanner, Clamex.Scanner.Clamdscan)

  @doc """
  Perform file scan

  ## Examples

      iex> Clamex.scan("virus.txt")
      {:error, :virus_found}

      iex> Clamex.scan("safe.txt")
      :ok

  ## Error reasons

  * `:virus_found` - file is infected
  * `:cannot_access_file` - file specified as `path` cannot be accessed
  * `:scanner_not_available` - scanner is not available at `executable_path`
  * `:cannot_connect_to_clamd` - ClamAV daemon is not running in background
  * any other error reported by the scanner will be returned as is (as String)

  """
  @spec scan(path :: Path.t()) :: :ok | {:error, atom()} | {:error, String.t()}
  def scan(path) do
    @scanner.scan(path)
  end

  @doc """
  Check if file is infected

  ## Examples

      iex> Clamex.virus?("virus.txt")
      true

      iex> Clamex.virus?("safe.txt")
      false

  """
  @spec virus?(path :: Path.t()) :: boolean
  def virus?(path) do
    case scan(path) do
      {:error, :virus_found} -> true
      _ -> false
    end
  end

  @doc """
  Check if file is safe

  ## Examples

      iex> Clamex.safe?("virus.txt")
      false

      iex> Clamex.safe?("safe.txt")
      true

  """
  @spec safe?(path :: Path.t()) :: boolean
  def safe?(path) do
    case scan(path) do
      :ok -> true
      _ -> false
    end
  end
end
