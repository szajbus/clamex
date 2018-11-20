defmodule Clamex.Scanner.ClamscanTest do
  use ExUnit.Case

  alias Clamex.Scanner.Clamscan

  test "file is safe" do
    path = "test/files/safe.txt"
    assert Clamscan.scan(path) == :ok
  end

  test "file is infected" do
    path = "test/files/virus.txt"
    assert Clamscan.scan(path) == {:error, :virus_found}
  end

  test "file does not exist" do
    path = "test/files/missing.txt"
    assert Clamscan.scan(path) == {:error, :cannot_access_file}
  end
end
