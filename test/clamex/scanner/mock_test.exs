defmodule Clamex.Scanner.MockTest do
  use ExUnit.Case

  alias Clamex.Scanner.Mock

  test "file is safe" do
    path = "safe.txt"
    assert Mock.scan(path) == :ok
  end

  test "file is infected" do
    path = "virus.txt"
    assert Mock.scan(path) == {:error, :virus_found}
  end

  test "file does not exist" do
    path = "missing.txt"
    assert Mock.scan(path) == {:error, :cannot_access_file}
  end

  test "cannot connect to daemon" do
    path = "no-daemon.txt"
    assert Mock.scan(path) == {:error, :cannot_connect_to_clamd}
  end

  test "scanner is not available" do
    path = "no-scanner.txt"
    assert Mock.scan(path) == {:error, :scanner_not_available}
  end
end
