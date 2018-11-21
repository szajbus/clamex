defmodule Clamex.Scanner do
  @moduledoc """
  Specification for scanner wrappers
  """

  @doc """
  Perform file scan
  """
  @callback scan(path :: Path.t()) ::
              :ok | {:error, atom()} | {:error, String.t()}
end
