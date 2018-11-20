defmodule Clamex.OutputTest do
  use ExUnit.Case

  alias Clamex.Output

  test "extracts cannot access file error" do
    output = "ERROR: Can't access file /wrong/path/to/file"
    assert Output.extract_error(output) == :cannot_access_file
  end

  test "extracts cannot connect to clamd error" do
    output =
      "ERROR: Could not connect to clamd on LocalSocket /usr/local/var/run/clamav/clamd.sock: No such file or directory"
    assert Output.extract_error(output) == :cannot_connect_to_clamd
  end

  test "extracts other error" do
    output = "ERROR: Some unexpected error"
    assert Output.extract_error(output) == "Some unexpected error"

    output = "Some unexpected error"
    assert Output.extract_error(output) == "Some unexpected error"
  end
end
