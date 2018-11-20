defmodule Clamex.Scanner do
  @callback scan(path :: Path.t()) ::
              :ok | {:error, atom()} | {:error, String.t()}
end
