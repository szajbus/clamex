defmodule Clamex.Scanner.ClamdscanTest do
  use ExUnit.Case

  alias Clamex.Scanner.Clamdscan

  test "file is safe" do
    path = "test/files/safe.txt"
    assert Clamdscan.scan(path) == :ok
  end

  test "file is infected" do
    path = "test/files/virus.txt"
    assert Clamdscan.scan(path) == {:error, :virus_found}
  end

  test "file does not exist" do
    path = "test/files/missing.txt"
    assert Clamdscan.scan(path) == {:error, :cannot_access_file}
  end
end
