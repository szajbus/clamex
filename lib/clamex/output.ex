defmodule Clamex.Output do
  @doc """
  Extract error message from scanner's output.

  Depending on error scenario and scanner used, error messages included in the
  output may be formatted in different ways.

  The error message is extracted in following way:
  - extract message from first line prefixed with "ERROR: "
  - if not found, extract message from first line prefixed with "WARNING: "
  - if not found, take the first line in full as the message

  """
  @spec extract_error(output :: String.t()) :: atom() | String.t()
  def extract_error(output) do
    lines = String.split(output, "\n")
    first_error(lines) || first_warning(lines) || first_line(lines)
  end

  defp first_error(lines) do
    lines
    |> Enum.find(&(&1 =~ ~r{^ERROR: }))
    |> strip_prefix
    |> match_message
  end

  defp first_warning(lines) do
    lines
    |> Enum.find(&(&1 =~ ~r{^WARNING: }))
    |> strip_prefix
    |> match_message
  end

  defp first_line(lines) do
    lines
    |> List.first()
    |> match_message
  end

  defp strip_prefix("ERROR: " <> message), do: message
  defp strip_prefix("WARNING: " <> message), do: message
  defp strip_prefix(message), do: message

  defp match_message(nil), do: nil

  defp match_message(message) do
    cond do
      message =~ ~r{Can't access file} -> :cannot_access_file
      message =~ ~r{Could not connect to clamd} -> :cannot_connect_to_clamd
      true -> message
    end
  end
end
