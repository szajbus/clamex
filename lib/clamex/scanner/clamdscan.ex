defmodule Clamex.Scanner.Clamdscan do
  @moduledoc """
  Wrapper for `clamdscan` command-line utility.
  """

  @behaviour Clamex.Scanner

  @default_args ["--no-summary", "--quiet"]

  def scan(path) do
    try do
      {output, exit_code} =
        System.cmd(
          "clamdscan",
          @default_args ++ [path],
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
