defmodule ClamexTest do
  use ExUnit.Case
  doctest Clamex

  test "file is safe" do
    path = "test/files/safe.txt"

    assert Clamex.scan(path) == :ok
    assert Clamex.safe?(path) == true
    assert Clamex.virus?(path) == false
  end

  test "file is infected" do
    path = "test/files/virus.txt"

    assert Clamex.scan(path) == {:error, :virus_found}
    assert Clamex.safe?(path) == false
    assert Clamex.virus?(path) == true
  end

  test "file does not exist" do
    path = "non-existent.txt"

    assert Clamex.scan(path) == {:error, :cannot_access_file}
    assert Clamex.safe?(path) == false
    assert Clamex.virus?(path) == false
  end
end
