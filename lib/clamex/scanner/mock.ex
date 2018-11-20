defmodule Clamex.Scanner.Mock do
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
