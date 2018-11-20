defmodule Clamex.Output do
  def extract_error("ERROR: Can't access file" <> _),
    do: :cannot_access_file

  def extract_error("ERROR: Could not connect to clamd" <> _),
    do: :cannot_connect_to_clamd

  def extract_error("ERROR: " <> message),
    do: extract_error(message)

  def extract_error(message),
    do: message
end
